//
//  NewUserViewController.swift
//  proyectoCaraLibro
//
//  Created by user191022 on 5/15/22.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class NewUserViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBOutlet weak var photoUpButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction private func tapToCloseKeyboard(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    @IBAction private func swipeToCloseKeyboard(_ sender: UISwipeGestureRecognizer) {
            self.view.endEditing(true)
        }
    
    @IBAction private func swipeToOpenKeyboard(_ sender: UISwipeGestureRecognizer) {
            self.txtName.becomeFirstResponder()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.HideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
           signUpButton.layer.cornerRadius = 15
        photoUpButton.layer.cornerRadius = 15
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
            //super.viewWillAppear(animated)
            //self.registerKeyboardNotifications()
        }

        override func viewWillDisappear(_ animated: Bool) {
            //super.viewWillDisappear(animated)
            //self.unregisterKeyboardNotifications()
        }
    
    @objc func Keyboard(notification: Notification){
        
        //let userInfo = notification.userInfo!
        
        //let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]) as! NSValue).cgRectValue
        let keyboardScreenEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }

    @IBAction func signUpButtonAction(_ sender: Any) {
        if emailTextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "Error", message: "Debe ingresar un correo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enter Bales", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            return
        }
        if passwordTextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "Error", message: "Debe ingresar una contrasena", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enter Bales", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            return
        }
        if password2TextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "Error", message: "Debe ingresar una contrasena", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enter Bales", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            return
        }
        if passwordTextField.text != password2TextField.text {
            let alert = UIAlertController(title: "Error", message: "Las contrasenas deben coincidir", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Enter Bales", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            return
        }

        
        login()
    }
    func login ()
    {
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result, error) in
                
                if let result = result, error == nil{
                    self.navigationController? .pushViewController(MenuViewController(), animated: true)
                    
                } else{
                    let alertController = UIAlertController(title: "Error", message: "Se ha producido un error", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
