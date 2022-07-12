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
        
        let url = URL(string: contact.url)!
        let request = URLRequest(url: url)
        
        // Create the HTTP request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                // Handle HTTP request error
                return
            } else if data != nil {
                // Handle HTTP request response
                DispatchQueue.global().async { [weak self] in
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.imgContact.image = image
                                    }
                                }
                            }
                        }            }
                        
        }
        task.resume()
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
