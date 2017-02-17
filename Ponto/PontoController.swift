//
//  PontoController.swift
//  Ponto
//
//  Created by scapeman on 07/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class PontoController: UIViewController {

    @IBOutlet weak var txt_relogio: UILabel!
    @IBOutlet weak var btn_entrada: UIButton!
    @IBOutlet weak var btn_entra_intervalo: UIButton!
    @IBOutlet weak var btn_sair_intervalo: UIButton!
    @IBOutlet weak var btn_sair: UIButton!
    
    var ref: FIRDatabaseReference!
    
    var empregado : Empregado!
    
    var pontoID : String?
    
    @IBOutlet weak var usuarioLogado: UILabel!
    
    var timer = Timer()
    
    var format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
        
        //Custom Format for clock
        format.dateFormat = "hh:mm"
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("empregado").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
             if snapshot.exists(){

                let value = snapshot.value as? NSDictionary
                let nome = value?["nome"] as! String
                let cargo = value?["cargo"] as! String
                let email = value?["email"] as! String
                let carga_horaria = value?["carga_horaria"] as! Float
                self.empregado = Empregado.init(nome: nome, cargo: cargo, email: email, carga_horaria: carga_horaria)
            
            }
            self.usuarioLogado.text = FIRAuth.auth()?.currentUser?.uid
        })
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).observe(.childAdded, with: { (snapshot) in
            
            if snapshot.exists(){
                self.pontoID = snapshot.key
            }
        })
        
        // Do any additional setup after loading the view.
        
       
    }
    
    @objc func tick() {
        txt_relogio.text = format.string	(from: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registraEntrada(_ sender: UIButton) {
        sender.isHidden = true
        btn_entra_intervalo.isHidden = false
        btn_sair.isHidden = false
        
        let ponto = Ponto.init(entrada: Date.init().description, entrada_intervalo: nil, saida_intervalo: nil, saida: nil)
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).childByAutoId().setValue(ponto.toDictionary())
        
        let alerta = UIAlertController(title: "Mensagem", message: "Entrada registrada", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)
    }

    @IBAction func registraIntervalo(_ sender: UIButton) {
        sender.isHidden = true
        btn_sair_intervalo.isHidden = false
        btn_sair.isHidden = false
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("entrada_intervalo").setValue(Date.init().description)
        
        let alerta = UIAlertController(title: "Mensagem", message: "Entrada de intervalo registrado", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)
    }
    
    @IBAction func sairIntervalo(_ sender: UIButton) {
        sender.isHidden = true
        btn_sair.isHidden = false
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("saida_intervalo").setValue(Date.init().description)
        
        let alerta = UIAlertController(title: "Mensagem", message: "Sair de intervalo registrado", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)
    }
    
    @IBAction func registraSaida(_ sender: UIButton) {
        sender.isHidden = true
        btn_entrada.isHidden = false
        btn_entra_intervalo.isHidden = true
        btn_sair_intervalo.isHidden = true
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("saida").setValue(Date.init().description)
        
        let alerta = UIAlertController(title: "Mensagem", message: "Saida  registrada", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
