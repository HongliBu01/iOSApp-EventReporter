//
//  CameraViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/15/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import GeoFire

/**
    define camera view controller to feed data to firebase
 */

class CameraViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    var selectedImage: UIImage?
    
    /// Instance of CLLocaitonManager for this view controller
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectImage))
        
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        // create CLLocation manager
        locationManager.delegate = self
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check permission status
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        // Handle all different levels of permissions
        switch authStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            return
            
        case .denied, .restricted:
            presentLocationServicesAlert("Location Services",
                                         message: "Please enable location services for this app in Settings.")
            return
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    /**
        enable post button only if image is selected
    */
    func handlePost() {
        if selectedImage != nil {
            self.postButton.isEnabled = true
            self.postButton.backgroundColor = UIColor(red:0, green:0.5, blue:0.7, alpha: 1)
        } else {
            self.postButton.isEnabled = false
            self.postButton.backgroundColor = .lightGray
            
        }
    }
    /**
     Show an alert with information about the location services status
    */
    func presentLocationServicesAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let affirmativeAction = UIAlertAction(title: "OK", style: .default) { (alertAction) -> Void in
            // Launch Settings.app directly to the app
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(affirmativeAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //MARK: -Gesture
    @objc func handleSelectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    /**
    action to post
    */
    
    @IBAction func postButton_Touch(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Loading...", interaction: false)
        if let postedImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(postedImage, 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Constant.STORAGE_ROOT_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }

                let photoUrl = metadata?.downloadURL()?.absoluteString
                print ("image: \(String(describing: photoUrl)) is uploaded")
                self.sendDataToDatabase(photoUrl: photoUrl!)
            })
        } else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
    /**
    action to home
    */
    @IBAction func backToHome(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToHomeVC", sender: nil)
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        //        let geoFire = GeoFire(firebaseRef: newPostReference)
        guard let currentUser = Auth.auth().currentUser else  {
            return
        }
        let currentUserId = currentUser.uid
        if (locationManager.location != nil){
            newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": captionTextView.text!, "description": descriptionTextView.text!, "lat": (locationManager.location?.coordinate.latitude)!, "lon": (locationManager.location?.coordinate.longitude)!], withCompletionBlock: {
                (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Success!")
                // clean up
                self.clean()
                self.handlePost()
                // switch to home page
            })
        } else{
            newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": captionTextView.text!, "description": descriptionTextView.text!], withCompletionBlock: {
                (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Success!")
                // clean up
                self.clean()
                self.handlePost()
                // switch to home page
            })
        }
        
    }
    
    /**
        clean text fields and image
     */
    
    func clean() {
        self.selectedImage = nil
        self.captionTextView.text = ""
        self.descriptionTextView.text = ""
        self.photo.image = UIImage(named: "imagePlaceholder")
    }
    
}

/**
    enable image picker
 */

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
/**
   implement location manager interface to retrieve location info
 */
extension CameraViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print("Current Location:\(String(describing: locations.last?.coordinate.latitude))" + "\(String(describing: locations.last?.coordinate.longitude))")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // Prompt user to perform figure 8 to recalibrate heading
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
    }
}


