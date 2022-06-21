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
import FirebaseStorage


class NewUserViewController: UIViewController ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UIApplicationDelegate{
    
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
        
        let documentUUID = UUID().uuidString
        let correo = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let nombre = nameTextField.text ?? ""
        let apellido = lastNameTextField.text ?? ""
        let path = "images/\(UUID().uuidString).jpg"
        
        Auth.auth().createUser(withEmail: correo, password: password) { (authResult, error) in
                    if error == nil{
                        self.db.collection("usuarios").document(documentUUID).setData([
                                                                            "nombre":nombre,
                                                                            "apellidos":apellido,
                                                                            "uid": authResult!.user.uid,
                                                                            "correo":correo,
                                                                            "url":path
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
            //if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.UploadImage(image: pickedImage)
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func UploadImage(image: UIImage)
        {
        
                let storageref = Storage.storage().reference()
                let imagenode = storageref.child("images/\(UUID().uuidString).jpg")
        
        let data = image.jpegData(compressionQuality: 0.2)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                if let data = data {
                        imagenode.putData(data, metadata: metadata) { (metadata, error) in
                                if let error = error {
                                        print("Error while uploading file: ", error)
                                }

                                if let metadata = metadata {
                                        print("Metadata: ", metadata)
                                }
                        }
                }
                
                        //imagenode.putData(image.pngData()!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let storage = Storage.storage()
        //let storageRef = storage.reference()
        
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
