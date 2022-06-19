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
    
    func validateFields() -> String? {
        
        
        return nil
    }


    @IBAction func signUpButtonAction(_ sender: Any){
        
        if let name = nameTextField.text, let lastname = lastNameTextField.text, let email = emailTextField.text,
           let password = passwordTextField.text, let image = imageView.image
        {
            let ref = Database.database().reference()
            guard let key = ref.child("users").childByAutoId().key else { return }
            let user = ["uid": userID,
                        "name": name,
                        "lastname": lastname,
                        "email": email,
                        "password": password,
                        "photo": image]
            let childUpdates = ["/users/\(key)": user,
                                "/user-users/\(userID)/\(key)/": user]
            ref.updateChildValues(childUpdates)
            
           }
           
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let ref = Database.database().reference()
        
        //ref.child("users").setValue(["email":"test1@gmail.com","password":"654321"])
        
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
