//
//  ViewController.swift
//  Ponto
//
//  Created by scapeman on 04/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var txt_login: UITextField!
    @IBOutlet weak var txt_senha: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_logar(_ sender: UIButton) {
        
     FIRAuth.auth()?.signIn(withEmail: txt_login.text!, password: txt_senha.text!, completion: { (usuario, erro) in
            if erro == nil {//sucesso
             
                print("Login com Sucesso: \(erro?.localizedDescription)")
                  self.performSegue(withIdentifier: "enviarDadosLogin", sender: self)
            }else{//erro
                print("Erro de login: \(erro?.localizedDescription)")
                
                let alert = UIAlertController(title: "Erro", message: "\(erro!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) )
                self.present(alert, animated: true)
            }
       })
    }

    @IBAction func btn_cadastrar(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: txt_login.text!, password: txt_senha.text!, completion: { (usuario, erro) in
            if erro == nil {//sucesso
                
                let ref = FIRDatabase.database().reference()                
                
                let empregado = Empregado.init(nome: "Teste", cargo: "cargoTeste", email: self.txt_login.text!, carga_horaria: 40)
                        
                ref.child("empregado").child(FIRAuth.auth()!.currentUser!.uid).setValue(empregado.toDictionary())
                
                print("Sucesso ao cadastrar usuário: \(erro?.localizedDescription)")
                self.performSegue(withIdentifier: "enviarDadosLogin", sender: self)
                
            }else{//erro
                print("Erro ao cadastrar usuário: \(erro?.localizedDescription)")
                
                let alert = UIAlertController(title: "Erro", message: "\(erro!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) )
                self.present(alert, animated: true)
            }
        })
        
    }
}

