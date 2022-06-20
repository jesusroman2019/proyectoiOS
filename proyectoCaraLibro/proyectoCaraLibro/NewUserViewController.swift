//
//  NewUserViewController.swift
//  proyectoCaraLibro
//
//  Created by user191022 on 5/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Firebase

class NewUserViewController: UIViewController ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate{
    
    private let db = Firestore.firestore()
    @IBOutlet private weak var anchorBottomScroll: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnAddPhotoButton: UIButton!
    @IBOutlet weak var btnSaveButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction private func tapToCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    

// registro
    @IBAction func signUpButtonAction(_ sender: Any){
        
        let correo = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let nombre = nameTextField.text ?? ""
        let apellido = lastNameTextField.text ?? ""
        //let foto = imageView.image
        
        Auth.auth().createUser(withEmail: correo, password: password) { (authResult, error) in
                    if error == nil{
                        self.db.collection("usuarios").document(correo).setData([
                                                                            "nombre":nombre,
                                                                            "apellidos":apellido,
                            //"foto":foto!
                        ])
                        let alertController = UIAlertController(title: "Mesaje", message: "Registro con exito", preferredStyle: UIAlertController.Style.alert)
                        
                        let closeAction = UIAlertAction (title: "Aceptar", style: .cancel/*, handler: self.signUpButtonAction(_:)*/)
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                    
                        
                    }else{
                        //self.showAlertWithTitle("Error", message: "Error en el Registro", accept: "Aceptar")
                    }
            
        }
        
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        imagePicker.delegate = self
        
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
