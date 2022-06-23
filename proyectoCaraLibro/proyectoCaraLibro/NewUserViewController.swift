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
    
    let documentUUID = UUID().uuidString    
    
    
    
    @IBAction private func tapToCloseKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func isValidEmail(emailID:String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: emailID)
   }
    
    
    func isPasswordValid(password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    

// registro
    @IBAction func signUpButtonAction(_ sender: Any){
        
       
        
        guard let nombre = self.nameTextField.text, nombre.count != 0 else {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese su nombre, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
            return
                        }
        
        guard let apellido = self.lastNameTextField.text, apellido.count != 0 else {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese sus apellidos, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
                        }
        
        guard let correo = self.emailTextField.text, correo.count != 0 else {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese su correo, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
                        }
        
        if isValidEmail(emailID: correo) == false {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese un correo valido, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
            
        }
        
        guard let password = self.passwordTextField.text, password.count != 0 else {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese su password, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
                        }
        
        if isPasswordValid(password : password) == false {
            let alertController = UIAlertController(title: "Error", message:
                    "El password debe contener una letra, un caracter especial y tener 8 caraacteres minimo, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
            
        }
        
        
        guard let confirmPassword = self.confirmPasswordTextField.text, confirmPassword.count != 0 else {
            let alertController = UIAlertController(title: "Error", message:
                    "Ingrese el mismo password otra vez, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
                            return
                        }
        
        if password != confirmPassword {
            let alertController = UIAlertController(title: "Error", message:
                    "La confirmacion de password debe coincidir con el password, por favor.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                self.present(alertController, animated: true, completion: nil)
            return
                }
        
        
        //let documentUUID = UUID().uuidString
        //let path = "images/\(UUID().uuidString).jpg"
        let path = "images/\(documentUUID)/profile_photo.jpg"
        
        Auth.auth().createUser(withEmail: correo, password: password) { (authResult, error) in
                    if error == nil{
                        self.db.collection("usuarios").document(self.documentUUID).setData([
                                                                            "nombre":nombre,
                                                                            "apellidos":apellido,
                                                                            "uid": authResult!.user.uid,
                                                                            "correo":correo,
                                                                            "url":path
                        ])
                        let alertController = UIAlertController(title: "Mesaje", message: "Registro con exito", preferredStyle: UIAlertController.Style.alert)
                        
                        let closeAction = UIAlertAction (title: "Aceptar", style: .cancel, handler: self.goBack(_:))
                        alertController.addAction(closeAction)
                        self.present(alertController, animated: true, completion: nil)
                    
                        
                    }else{
                      
                        let alertController = UIAlertController(title: "Error", message:
                                "Error en el Registro.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))

                            self.present(alertController, animated: true, completion: nil)
                                        return                    }
            
        }
        
    }
    
    @IBAction func goBack(_ sender: Any) {
              self.navigationController?.popToRootViewController(animated: true)
         }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    
  

    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
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
                //let imagenode = storageref.child("images/\(UUID().uuidString).jpg")
                let imagenode = storageref.child("images/\(documentUUID)/profile_photo.jpg")
        
        let data = image.jpegData(compressionQuality: 0.2)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                if let data = data {
                        imagenode.putData(data, metadata: metadata) { (metadata, error) in
                                if let error = error {
                                        print("Error al subir la foto: ", error)
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
