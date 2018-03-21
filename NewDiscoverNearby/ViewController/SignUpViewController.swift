//
//  SignUpViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/11/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
/**
    View Controller for sign up page
 */

class SignUpViewController: UIViewController {
    //MARK: -Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        handleTextField()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: -textfield validation
    
    /**
        this two methods is to
        hanle text field in view, includind user, email and password text field
        enable sign up button only when all infomation is validate
    */
    func handleTextField() {
        userField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = userField.text, !username.isEmpty, let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signUpButton.isEnabled = false
                return
        }
        
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    //MARK: -Gesture
    /**
     handle profile image picking
    */
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Signup button
    /**
      define sign up behavior, collect feedback
    */
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Loading...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            LogService.signUp(username: userField.text!, email: emailField.text!, password: passwordField.text!, imageData: imageData, onSuccess: {
                
                print("user: \(String(describing: self.userField.text)) has signed up successfully")
                
                ProgressHUD.showSuccess("Success!")
                
                self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
            }, onError: { (errorString) in
                ProgressHUD.showError(errorString)
            })
        } else {
            ProgressHUD.showError("Upload a profile image please!")
        }
    }
    
}
/**
    delegate for image picker
 */
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

