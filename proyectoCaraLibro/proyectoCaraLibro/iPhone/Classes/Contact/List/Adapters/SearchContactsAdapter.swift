//
//  SearchContactsAdapter.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit

class SearchContactsAdapter: NSObject {
    
    private unowned let controller: ContactsViewController
    
    var arrayData = [Contact]()
    
    init(controller: ContactsViewController) {
        self.controller = controller
    }
}

extension SearchContactsAdapter: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.controller.setResultOfSearchContacts(self.arrayData)
            
        } else {
            
            let result = self.arrayData.filter { contact in
                
                let nombre = contact.nombre.lowercased()
                let text = searchText.lowercased()
                
                return nombre.contains(text)
            }
            
            let arrayToShow: [Any] = result.count != 0 ? result : ["No se encontraron resultados para la búsqueda de:\n\n\(searchText)"]
            
            self.controller.setResultOfSearchContacts(arrayToShow)
        }
    }
}
