//
//  Empregado.swift
//  Ponto
//
//  Created by scapeman on 14/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class Empregado: NSObject {

    var nome : String
    var cargo : String
    var email : String
    var carga_horaria : Float
    
    init(nome: String, cargo: String, email: String, carga_horaria : Float) {
        self.nome = nome
        self.cargo = cargo
        self.email = email
        self.carga_horaria = carga_horaria
    }
    
    func toDictionary() -> [String:Any]{
        return ["nome": self.nome, "cargo": self.cargo, "email": self.email, "carga_horaria": self.carga_horaria]
    }
}
