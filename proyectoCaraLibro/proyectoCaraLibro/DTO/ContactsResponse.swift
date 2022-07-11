//
//  ContactsResponse.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/10/22.
//

import Foundation

struct PageContactDTO: Decodable {
    let page: Int?
    let results: [ContactDTO]?
}

struct ContactDTO: Decodable {
    let uid: String?
    let nombre: String?
    let apellidos: String?
    let correo: String?
    let telefono: Int?
    let url: String?
}


