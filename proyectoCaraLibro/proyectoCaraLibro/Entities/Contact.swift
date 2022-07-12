//
//  Contact.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import Foundation

struct Contact {
    
    let uid: String
    let nombre: String
    let apellidos: String
    let correo: String
    let telefono: Int
    let url: String
    
    
    init(dto: ContactDTO) {
        
        self.uid = dto.uid ?? "--"
        self.nombre = dto.nombre ?? "--"
        self.apellidos = dto.apellidos ?? "--"
        self.correo = dto.correo ?? "--"
        self.telefono = dto.telefono ?? 0
        self.url = dto.url ?? "--"
        
    
    }
}

extension ContactDTO {
    var toContact: Contact {
        return Contact(dto: self)
    }
}

extension Array where Element == ContactDTO {
    
    var toContacts: [Contact] {
        return self.map({ $0.toContact })
    }
    

}
