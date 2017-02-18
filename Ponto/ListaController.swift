//
//  ListaController.swift
//  Ponto
//
//  Created by scapeman on 18/02/17.
//  Copyright © 2017 fa7. All rights reserved.
//

import UIKit
import Firebase

class ListaController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : FIRDatabaseReference!

    @IBOutlet weak var listaHoras: UITableView!
    
    var items = [Ponto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("ponto").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            self.items.removeAll()
            for snapshotChild in snapshot.children {
                let child = snapshotChild as! FIRDataSnapshot
                let value = child.value as! [String:Any]?
                
                let entrada = value?["entrada"] as! String
                let entrada_intervalo = value?["entrada_intervalo"] as! String?
                let saida_intervalo = value?["saida_intervalo"] as! String?
                let saida = value?["saida"] as! String?
                
                
                let item = Ponto(entrada: entrada, entrada_intervalo: entrada_intervalo, saida_intervalo: saida_intervalo, saida: saida )
                
                self.items.append(item)
                
            }
            
            self.listaHoras.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PontoCell", for: indexPath)
        
        let ponto = self.items[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
 
        var tempoTotal = 0
        var tempoIntervalo = 0
        let entrada = dateFormatter.date(from: ponto.entrada)
        
        if(ponto.saida != nil) {
            let saida = dateFormatter.date(from: ponto.saida!)
           
            tempoTotal = Calendar.current.dateComponents([.second], from: entrada!, to: saida!).second!
        }
        
        if(ponto.entrada_intervalo != nil && ponto.saida_intervalo != nil) {
            let entrada_intervalo = dateFormatter.date(from: ponto.entrada_intervalo!)
            let saida_intervalo = dateFormatter.date(from: ponto.saida_intervalo!)
            
            tempoIntervalo = Calendar.current.dateComponents([.second], from: entrada_intervalo!, to: saida_intervalo!).second!
        }
        
        let tempo = tempoTotal - tempoIntervalo
        
        let diaFormatter = DateFormatter()
        diaFormatter.dateFormat = "dd/MM/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        cell.textLabel?.text = diaFormatter.string(from: entrada!)
        cell.detailTextLabel?.text = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(tempo)))
        return cell
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
