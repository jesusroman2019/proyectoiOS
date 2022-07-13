//
//  ContactDetailViewController.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //@IBOutlet private weak var scrollContent: UIScrollView!
    @IBOutlet private weak var scrollContent: UIScrollView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblLastName: UILabel!
    @IBOutlet private weak var lblEmail: UILabel!
    @IBOutlet private weak var lblPhone: UILabel!
    @IBOutlet private weak var imgContact: UIImageView!
    
    
    var idContact: String!
    
    /*
    @IBAction private func clickBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }*/
    
    @IBAction private func clickBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)    }
    
    
    private func updateData(_ contact: Contact) {
        
        self.lblName.text = contact.nombre
        self.lblLastName.text = contact.apellidos
        self.lblEmail.text = contact.correo
        self.lblPhone.text = String(contact.telefono)

        
        
        /*
        let request = AF.request(movie.urlImage)
        request.response { dataResponse in
            guard let data = dataResponse.data else { return }
            let image = UIImage(data: data)
            self.imgMovie.image = image
            self.imgMovieBackground.image = image
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgContact.layer.cornerRadius = 10
        self.getDetail()
    }
    
    private func getDetail() {
        
        let webService = ContactWS()
        
        self.showLoading(true)
        webService.getDetailById(self.idContact) { contactDTO in
            
            self.showLoading(false)
            self.updateData(contactDTO.toContact)
            
        } error: { errorMessage in
            
            self.showLoading(true)
            print(errorMessage)
        }
    }
    
    private func showLoading(_ isLoading: Bool) {
        self.scrollContent.isHidden = isLoading
    }
}

extension ContactDetailViewController {
    
    class func buildWithIdContact(_ idContact: String) -> ContactDetailViewController {
        
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController
        controller?.idContact = idContact
        
        return controller ?? ContactDetailViewController()
    }
}
