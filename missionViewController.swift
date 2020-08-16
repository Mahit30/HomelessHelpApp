//
//  missionViewController.swift
//  HomelessHelp
//
//  Created by Mahit  Tanikella on 8/12/20.
//  Copyright © 2020 Mahit  Tanikella. All rights reserved.
//

import UIKit
import FirebaseAuth

class missionViewController: UIViewController {

    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
