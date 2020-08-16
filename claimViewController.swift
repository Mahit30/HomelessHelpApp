//
//  claimViewController.swift
//  HomelessHelp
//
//  Created by Mahit  Tanikella on 8/12/20.
//  Copyright © 2020 Mahit  Tanikella. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
//import Cocoa
import MapKit
import CoreLocation
import Foundation

class claimViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var documents: [QueryDocumentSnapshot] = []
    var tit: String = ""
    var tit2: String = ""
    var userLocation: CLLocationCoordinate2D? = nil
    var distance: Double = 0.0
    let locationManager = CLLocationManager()
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
        }
        
        let db = Firestore.firestore()
        db.collection("masterCollection").getDocuments() { (querySnapshot, err) in
            if let err = err {
                      print("Error getting documents: \(err)")
            } else {
                  for document in querySnapshot!.documents {
                      self.documents.append(document)
                  }
            }
            self.scrollView.isScrollEnabled = true
            self.scrollView.isHidden = false
            self.scrollView.isUserInteractionEnabled = true
            self.scrollView.showsVerticalScrollIndicator = true
            self.scrollView.showsHorizontalScrollIndicator = true
    }
         self.getDistance()
}
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
    
    @objc func buttonAction(sender: UIButton!) {
        var buttonTitle = sender.title(for: .normal)!
        var words = buttonTitle.split(separator: ":")
        tit = String(words[0])
        tit2 = String(words[1])
        performSegue(withIdentifier: "Information", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is infoViewController {
            let vc = segue.destination as? infoViewController
            vc?.documents = documents
            vc?.tit = tit
            vc?.tit2 = tit2
        }

    }
    
    func getDistance() {
        let db = Firestore.firestore()
        db.collection("masterCollection").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let address = document.get("Address") as! String
                    
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(address) { (placemarks, error) in
                        let placemarks = placemarks
                        let location = placemarks?.first?.location
                        if(self.userLocation != nil) {
                            let actualUserLocation = CLLocation(latitude: self.userLocation!.latitude, longitude: self.userLocation!.longitude)
                            self.distance = location!.distance(from: actualUserLocation)
                            document.reference.updateData(["Distance": self.distance])
                        }
                        else {
                            return
                        }
                        // Use your location
                        //self.documents.append(document)
                    }
                }
            }
        }
        db.collection("masterCollection").order(by: "Distance", descending: false)
        addButtons()
    }
    
    func addButtons() {
        let db = Firestore.firestore()
        db.collection("masterCollection").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var ycoor = 0
                for document in querySnapshot!.documents {
                    if(document.get("Units") as AnyObject? === 0 as AnyObject){
                        continue
                    }
                    let button = UIButton(frame: CGRect(x: 0, y: ycoor, width: Int(self.scrollView.frame.size.width), height: 60))
                    button.backgroundColor = .orange
                    if document.get("Restaurant") == nil {
                       button.setTitle((document.get("Meal") as! String), for: .normal)
                    }
                    else {
                        var restaurant = document.get("Restaurant") as! String
                        var meal = document.get("Meal") as! String
                        button.setTitle(restaurant + ":" + meal, for: .normal)
                    }
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.centerXAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.centerXAnchor)
                    button.centerYAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.centerYAnchor)
                    self.scrollView.addSubview(button)
                    ycoor += 70
                }
            }
        }
    }
       // Do any additional setup after loading the views

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            userLocation = manager.location?.coordinate
            print("locations = \(userLocation!.latitude) \(userLocation!.longitude)")
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

