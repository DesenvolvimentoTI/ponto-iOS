//
//  Empresa.swift
//  Ponto
//
//  Created by scapeman on 14/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class Empresa: NSObject {
    
    var nome : String
    var endereco: String
    var coordenadax: CLong
    var coordenaday : CLong
    
    
    init (nome: String, endereco: String, coordenadax:CLong, coordenaday: CLong){
        self.nome = nome
        self.endereco = endereco
        self.coordenadax = coordenadax
        self.coordenaday = coordenaday
    }
    
    func toDictionary() -> [String:Any]{
        return ["nome": self.nome, "endereco": self.endereco, "coordenadax": self.coordenadax, "coordenaday": self.coordenaday]
    }
}

