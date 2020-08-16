//
//  ViewController.swift
//  HomelessHelp
//
//  Created by Mahit  Tanikella on 8/10/20.
//  Copyright © 2020 Mahit  Tanikella. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func signOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          signInButton.isHidden = false
          registerButton.isHidden = false
          self.navigationItem.rightBarButtonItem = nil
        } catch let signOutError as NSError {
          let alertController = UIAlertController(title: "Error", message:
          "Hello", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
          self.present(alertController, animated: true, completion: nil)
        }
          
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            signInButton.isHidden = false
            registerButton.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
        } else {
            signInButton.isHidden = true
            registerButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
        }
    }
    
    @IBAction func missionButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mission")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    @IBAction func getStartedTapped(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "claimAndDonate")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    @IBAction func signInTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "login")
               vc.modalPresentationStyle = .overFullScreen
               present(vc, animated: true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "signUp")
               vc.modalPresentationStyle = .overFullScreen
               present(vc, animated: true)
    }
    
}

