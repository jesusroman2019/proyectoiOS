//
//  ContactsViewController.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit
import FirebaseAuth

class ContactsViewController: UIViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var tlvContacts: UITableView!
    @IBOutlet private weak var srcContacts: UISearchBar!
    
    @IBAction private func tapToCloseKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)

    }

    @IBAction func closeSessionButtonAction(_ sender: Any){
        
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
            
        } catch{
            //Se ha producido un error
        }
        
    }
    
    lazy var listAdapter = ListContactsAdapter(controller: self)
    
    lazy var searchAdapter: SearchContactsAdapter = {
        let adapter = SearchContactsAdapter(controller: self)
        return adapter
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tlvContacts.addSubview(self.refreshControl)
        self.setupAdapters()
        self.getAllContacts()
        
        //navigationItem.setHidesBackButton(true, animated: false)
       
        
        //self.tlvContacts.dataSource = self
    }
        

    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        self.getAllContacts()
    }
    
    private func getAllContacts() {
        
        let ws = ContactWS()
        
        self.refreshControl.beginRefreshing()
        
        ws.getAllContacts { arrayContactsDTO in
            
            self.refreshControl.endRefreshing()
            let arrayData = arrayContactsDTO.toContacts
            self.listAdapter.arrayData = arrayData
            self.searchAdapter.arrayData = arrayData
            self.tlvContacts.reloadData()
        }
    }
    
    private func setupAdapters() {
        self.tlvContacts.dataSource = self.listAdapter
        //self.tlvContacts.delegate = self.listAdapter
        self.srcContacts.delegate = self.searchAdapter
    }
    
    func setResultOfSearchContacts(_ arrayData: [Any]) {
        self.listAdapter.arrayData = arrayData
        self.tlvContacts.reloadData()
    }
    /*
    func openDetailContact(_ contact: Contact) {
        let controller = ContactDetailViewController.buildWithIdContact(contact.uid)
        self.navigationController?.pushViewController(controller, animated: true)
    }*/
    
        
    
    
    func showChatController(_ contact: Contact) {
        let controller = ChatLogController.buildWithIdContact(contact.uid)
        //let controller = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
        print(123)
    }
    
}


