//
//  HomeViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/13/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
/**
    define home view controller for showing images and events
 */

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var posts = [Retrieve]()
    var users = [UserInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        retrievePosts()
        
    }
    // MARK: - retrieve
    /**
     retrieve data from firebase into tableview
    */
    func retrievePosts() {
        activityIndicator.startAnimating()
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                print(dict)
                let newPost = Retrieve.transformPostPhoto(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    print("retrieved data: \(newPost)")
                    self.posts.append(newPost)
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                })
            }
        }
    }
    /**
     in the meanwhile, fetch user info
    */
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
    /**
     log out and clear current user info
    */
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }catch let logoutError{
            print(logoutError)
            
        }
        
    }
    /**
     jump to camera view
    */
    @IBAction func JumpToCamera_Touch(_ sender: Any) {
        self.performSegue(withIdentifier: "JumpToCameraVC", sender: nil)
    }
    
    
}

/**
  fetch data and show in cell
 */

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
}
