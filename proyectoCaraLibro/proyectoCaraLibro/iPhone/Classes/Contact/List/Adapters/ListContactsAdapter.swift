//
//  ListContactsAdapter.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit

class ListContactsAdapter: NSObject {
    
    private unowned let controller: ContactsViewController
    var arrayData = [Any]()
    
    init(controller: ContactsViewController) {
        self.controller = controller
    }
}

extension ListContactsAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let element = self.arrayData[indexPath.row]
        
        if let contact = element as? Contact {
            return ContactTableViewCell.buildIn(tableView, indexPath: indexPath, contact: contact)
            
        } else if let errorMessage = element as? String {
            return ErrorTableViewCell.buildIn(tableView, indexPath: indexPath, errorMessage: errorMessage)
            
        } else {
            return UITableViewCell()
        }
    }
}
/*
extension ListContactsAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let objContact = self.arrayData[indexPath.row] as? Contact {
            //self.controller.openDetailContact(objContact)
            self.controller.openChatContact(objContact)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.arrayData[indexPath.row] {
        case is Contact:
            return UITableView.automaticDimension
        case is String:
            return tableView.frame.height
        default:
            return 0
        }
    }
}*/
