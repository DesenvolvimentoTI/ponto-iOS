//
//  Ponto.swift
//  Ponto
//
//  Created by scapeman on 14/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class Ponto: NSObject {
    
    var entrada : String
    var entrada_intervalo: String?
    var saida_intervalo: String?
    var saida : String?
    
    
    init (entrada: String, entrada_intervalo: String?, saida_intervalo:String?, saida: String?){
        self.entrada = entrada
        self.entrada_intervalo = entrada_intervalo
        self.saida_intervalo = saida_intervalo
        self.saida = saida
    }
    
    func toDictionary() -> [String:Any]{
        return ["entrada": self.entrada as Any, "entrada_intervalo": self.entrada_intervalo as Any, "saida_intervalo": self.saida_intervalo as Any, "saida": self.saida as Any]
    }
}
