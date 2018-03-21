//
//  SplashViewController.swift
//  NewDiscoverNearby
//
//  Created by bhl on 3/17/18.
//  Copyright © 2018 UChicago. All rights reserved.
//

import UIKit

/**
  load splash screen when launching
 */

class SplashViewController: UIViewController {
    
    var autoDismiss = false
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func topContinue(_ sender: Any) {
          self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        
        // If auto-dismissing hide the button and rely on tap to dismiss
        if self.autoDismiss {
            self.dismissButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true, completion: {
                    print("done")
                })
            }
        }
    }
}
