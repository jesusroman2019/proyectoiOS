//
//  NewUserViewController.swift
//  proyectoCaraLibro
//
//  Created by user191022 on 5/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewUserViewController: UIViewController {
    
    @IBOutlet private weak var anchorBottomScroll: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnAddPhotoButton: UIButton!
    @IBOutlet weak var btnSaveButton: UIButton!
    
    @IBAction private func tapToCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any){
        
        if let email = emailTextField.text, let password = passwordTextField.text
        
        {
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                
                if let result = result, error == nil {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Second", bundle:nil)
                    let resultViewController = storyBoard.instantiateViewController(withIdentifier: "contactos") as! HomeViewController
                    self.navigationController?
                        .pushViewController(resultViewController, animated: true)
                        print(result)
                } else {
                    
                    let alertController = UIAlertController(title: "Error",
                        message:
                        "Se ha producido un error",
                            preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar",
                            style: .default))
                            
                        self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        
        ref.child("users").setValue(["email":"test1@gmail.com","password":"654321"])
        
        //ref.childByAutoId().setValue(["email":"test1@gmail.com","password":"654321"])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
    }    
    
}


//MARK: - Keyboard events
extension NewUserViewController {
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func unregisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
