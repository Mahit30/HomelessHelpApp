//
//  donateViewController.swift
//  HomelessHelp
//
//  Created by Mahit  Tanikella on 8/11/20.
//  Copyright © 2020 Mahit  Tanikella. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseAuth

class donateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var meal: UITextField!
    @IBOutlet weak var restaurant: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var units: UITextField!
    @IBOutlet weak var expiration: UITextField!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard!.instantiateViewController(identifier: "claimAndDonate")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          self.navigationItem.rightBarButtonItem = nil
        } catch let signOutError as NSError {
          let alertController = UIAlertController(title: "Error", message:
          "Hello", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
          self.present(alertController, animated: true, completion: nil)
        }
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let food = meal?.text
        let restaurantName = restaurant?.text
        let addressName = address?.text
        let unit = units?.text
        let hours = expiration?.text
        
        meal?.text = ""
        restaurant?.text = ""
        address?.text = ""
        units?.text = ""
        expiration?.text = ""

        let db = Firestore.firestore()
        //
        db.collection("masterCollection").document(String(Int.random(in: 10000..<100000))).setData(["Address": addressName, "Meal": food, "Restaurant": restaurantName, "Units": Int(unit!), "Expiration": Int(hours!)])
    }
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
