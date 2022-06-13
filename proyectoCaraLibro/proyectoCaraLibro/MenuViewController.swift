//
//  MenuViewController.swift
//  proyectoCaraLibro
//
//  Created by user191222 on 6/8/22.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController{
    
    
    @IBOutlet weak var LogOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogOutButton.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    @IBAction func closeSessionButtonAction(_ sender: Any) {
        do{
        try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch{
            
        }
    }
}
