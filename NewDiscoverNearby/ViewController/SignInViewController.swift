//
//  SignInViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/12/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
/**
 View Controller for sign up page
 */
class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    /// Instance of CLLocaitonManager for this view controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        handleTextField()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }
    }
    // MARK: -textfield validation
    
    /**
     this two methods is to
     hanle text field in view, including email and password text field
     enable sign in button only when all infomation is validate
     */
    func handleTextField() {
        emailField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Load...", interaction: false)
        LogService.signIn(email: emailField.text!, password: passwordField.text!, onSuccess: {
            print("user with email ad : \(String(describing: self.emailField.text)) has logged in")
            ProgressHUD.showSuccess("Success!")
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }, onError: { error in
            ProgressHUD.showError(error!)
        })
    }
    
}


