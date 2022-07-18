//
//  ContactWS.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/10/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


typealias ContactsHandler = (_ arrayContactsDTO: [ContactDTO]) -> Void
typealias ContactHandler = (_ contactDTO: ContactDTO) -> Void
typealias ErrorHandler = (_ errorMessage: String) -> Void

struct ContactWS {
    
    func getAllContacts(completionHandler: @escaping ContactsHandler) {        
        
        let url = URL(string: "https://proyecto-ios-2022-default-rtdb.firebaseio.com/contactos.json")!
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                // Handle HTTP request error
                DispatchQueue.main.async {
                    completionHandler([])
                }
                
                return
                
            } else if let data = data {
                // Handle HTTP request response
                let decoder = JSONDecoder()
                let response = try? decoder.decode(PageContactDTO.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response?.results ?? [])
                }
                
                
                //let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json ?? "xxxx")
            }
        }
        
        task.resume()
        
    }

    func getDetailById(_ idContact: String, success: @escaping ContactHandler, error: @escaping ErrorHandler) {
        
        //let urlString = "https://api.themoviedb.org/3/movie/\(idContact)?api_key=752cd23fdb3336557bf3d8724e115570&language=es"
        
        let urlString = """
                                https://proyecto-ios-2022-default-rtdb.firebaseio.com/contactos/results.json?orderBy="uid"&equalTo=\(idContact)
                                """
        
        let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: encodedStr)!
        
                
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if error != nil {
                // Handle HTTP request error
                //error("Error en la conexión de internet")
                print("Error en la conexión de internet")
                return
                
            } else if let data = data {
                // Handle HTTP request response
                let decoder = JSONDecoder()
                let response = try? decoder.decode(ContactDTO.self, from: data)
                
                guard response != nil else {
                    //error("No se puede leer la información recibida. Intentalo más tarde.")
                    print("No se puede leer la información recibida. Intentalo más tarde.")
                    return
                }
                
                success(response!)
                //let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(json ?? "xxxx")
            }
        }
        
        task.resume()
        
    }
}
