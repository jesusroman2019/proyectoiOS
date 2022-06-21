//
//  RecoverPasswordViewController.swift
//  proyectoCaraLibro
//
//  Created by user191022 on 5/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class RecoverPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet private weak var anchorBottomScroll: NSLayoutConstraint!
    
    @IBAction private func tapToCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnRecoverPassword(_ sender: Any){
        
        let correo = emailTextField.text ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: correo) { (error) in
                    if error == nil{
                        let alertController = UIAlertController(title: "Mensaje", message: "Correo enviado", preferredStyle: UIAlertController.Style.alert)
                        
                        let closeAction = UIAlertAction (title: "Aceptar", style: .cancel/*, handler: self.btnRecoverPassword(_:)*/)
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        
                        let alertController = UIAlertController(title: "Error", message: "Correo no valido", preferredStyle: .alert)
                                                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                                                    
                                                self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
        
        
        
        
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
extension RecoverPasswordViewController {
    
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
