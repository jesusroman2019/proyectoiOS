//
//  ContactTableViewCell.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var imgContact: UIImageView!
    
    
    func updateData(_ contact: Contact) {
            
        self.animateAppear()
        
        self.lblName.text = contact.nombre
                
        /*
        let request = AF.request(movie.urlImage)
        request.response { dataResponse in
            guard let data = dataResponse.data else { return }
            self.imgMovie.image = UIImage(data: data)
        }*/
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imgContact.layer.cornerRadius = 10
    }
    
    private func animateAppear() {
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

extension ContactTableViewCell {
    
    class func buildIn(_ tableView: UITableView, indexPath: IndexPath, contact: Contact) -> ContactTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell
        cell?.updateData(contact)
        return cell ?? ContactTableViewCell()
    }
}
