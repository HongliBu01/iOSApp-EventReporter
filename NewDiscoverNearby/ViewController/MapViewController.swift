//
//  MapViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/16/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreLocation
/**
    define map view based on MapKit
 */

class MapViewController: UIViewController {
    var matchingItems = [MKMapItem]()
    var posts = [Retrieve]()
    var users = [UserInfo]()
    var mapannotation = [MapAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet { mapView.delegate = self }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let miles: Double = 500 * 1600
        
        // Set a center point
        let zoomLocation = CLLocationCoordinate2DMake(-81.37944,28.53806)
        
        // Creat the region we want to see
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, miles, miles)
        
        // Set the initial region on the map
        mapView.setRegion(viewRegion, animated: true)
        
        mapView.register(mapAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        retrievePosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Annotations
    /**
     this two methods is to retrieve post data according to location and add annotations to map
    */
    
    func retrievePosts() {
        activityIndicator.startAnimating()
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                print(dict)
                
                let newPost = Retrieve.transformPostPhoto(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    if (newPost.lat != nil && newPost.lon != nil && newPost.caption != nil){
                        let coordinates = CLLocationCoordinate2DMake(newPost.lat!, newPost.lon!)
                        print("Coordinate: \(coordinates) is now be added to map")
                        let annotation = MapAnnotation(title: newPost.caption!, textBody: newPost.description!, coordinate: coordinates)
                        self.mapView.addAnnotation(annotation)
                        self.mapannotation.append(annotation)
                        self.mapView.showAnnotations(self.mapannotation, animated: true)
                        self.activityIndicator.stopAnimating()
                    }
                    
                })
            }
        }
    }
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserInfo.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
    }
    
}
/**
 MKMapView Delegate
*/
extension MapViewController: MKMapViewDelegate {
    // Draw the routing overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}


