//
//  PontoController.swift
//  Ponto
//
//  Created by scapeman on 07/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class PontoController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txt_relogio: UILabel!
    @IBOutlet weak var btn_entrada: UIButton!
    @IBOutlet weak var btn_entra_intervalo: UIButton!
    @IBOutlet weak var btn_sair_intervalo: UIButton!
    @IBOutlet weak var btn_sair: UIButton!
    
    var ref: FIRDatabaseReference!
    
    var pontoID : String?
    
    var timer = Timer()
    
    var format = DateFormatter()
    
    //gps localizador
    var locationManager = CLLocationManager()
    var coordenadaAtual = CLLocationCoordinate2D.init()
    var posEmpresa : CLLocation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gps
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
        
        //Custom Format for clock
        format.dateFormat = "hh:mm"
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("empresa").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                let coordenadax = value?["coordenadax"] as! Double
                let coordenaday = value?["coordenaday"] as! Double
                self.posEmpresa = CLLocation(latitude: coordenadax, longitude: coordenaday)
            }
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
       
        //Teste de area
        //gps
        let posEmpregado = CLLocation(latitude: coordenadaAtual.latitude, longitude: coordenadaAtual.longitude)
        
        let distance = posEmpregado.distance(from: posEmpresa!) / 1000
        print (distance)
        
        
        print("Latitude \(posEmpregado.coordinate.latitude)")
        print("Longitude \(posEmpregado.coordinate.longitude)")

        
        
        
        if distance > 1 {
            
                        let alerta = UIAlertController(title: "Registro não Permitido", message: "Usuário encontra-se fora da empresa", preferredStyle: UIAlertControllerStyle.alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alerta, animated: true)
        } else {
        
            sender.isHidden = true
            btn_entra_intervalo.isHidden = false
            btn_sair.isHidden = false

            
        let ponto = Ponto.init(entrada: Date.init().description, entrada_intervalo: nil, saida_intervalo: nil, saida: nil)
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).childByAutoId().setValue(ponto.toDictionary())
        
        let alerta = UIAlertController(title: "Mensagem", message: "Entrada registrada", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)
    }
    }
    @IBAction func registraIntervalo(_ sender: UIButton) {
        let posEmpregado = CLLocation(latitude: coordenadaAtual.latitude, longitude: coordenadaAtual.longitude)
        
        let distance = posEmpregado.distance(from: posEmpresa!) / 1000
        print (distance)
        
        
        print("Latitude \(posEmpregado.coordinate.latitude)")
        print("Longitude \(posEmpregado.coordinate.longitude)")
        
        
        
        
        if distance > 1 {
            
            let alerta = UIAlertController(title: "Registro não Permitido", message: "Usuário encontra-se fora da empresa", preferredStyle: UIAlertControllerStyle.alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alerta, animated: true)
        } else {

        sender.isHidden = true
        btn_sair_intervalo.isHidden = false
        btn_sair.isHidden = false
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("entrada_intervalo").setValue(Date.init().description)
        
        let alerta = UIAlertController(title: "Mensagem", message: "Entrada de intervalo registrado", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)
        }
        
    }
    
    @IBAction func sairIntervalo(_ sender: UIButton) {
        let posEmpregado = CLLocation(latitude: coordenadaAtual.latitude, longitude: coordenadaAtual.longitude)
        
        let distance = posEmpregado.distance(from: posEmpresa!) / 1000
        print (distance)
        
        
        print("Latitude \(posEmpregado.coordinate.latitude)")
        print("Longitude \(posEmpregado.coordinate.longitude)")
        
        
        
        
        if distance > 1 {
            
            let alerta = UIAlertController(title: "Registro não Permitido", message: "Usuário encontra-se fora da empresa", preferredStyle: UIAlertControllerStyle.alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alerta, animated: true)
        } else {

        
        sender.isHidden = true
        btn_sair.isHidden = false
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("saida_intervalo").setValue(Date.init().description)
        
        let alerta = UIAlertController(title: "Mensagem", message: "Sair de intervalo registrado", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
            present(alerta, animated: true)}
    }
    
    @IBAction func registraSaida(_ sender: UIButton) {
    
        let posEmpregado = CLLocation(latitude: coordenadaAtual.latitude, longitude: coordenadaAtual.longitude)
        
        let distance = posEmpregado.distance(from: posEmpresa!) / 1000
        print (distance)
        
        
        print("Latitude \(posEmpregado.coordinate.latitude)")
        print("Longitude \(posEmpregado.coordinate.longitude)")
        
        
        
        
        if distance > 1 {
            
            let alerta = UIAlertController(title: "Registro não Permitido", message: "Usuário encontra-se fora da empresa", preferredStyle: UIAlertControllerStyle.alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alerta, animated: true)
        } else {

        sender.isHidden = true
        btn_entrada.isHidden = false
        btn_entra_intervalo.isHidden = true
        btn_sair_intervalo.isHidden = true
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).child(pontoID!).child("saida").setValue(Date.init().description)
        
        
        let alerta = UIAlertController(title: "Mensagem", message: "Saida  registrada", preferredStyle: UIAlertControllerStyle.alert)
        
        alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alerta, animated: true)

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  let localizacaoAtual = manager.location!.coordinate
        
        coordenadaAtual.latitude = manager.location!.coordinate.latitude
        coordenadaAtual.longitude = manager.location!.coordinate.longitude
        
        
        
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
