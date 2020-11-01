//
//  MainTableViewController.swift
//  Theathre
//
//  Created by Евгений on 26.10.2020.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    
    
    // MARK: - VAR,LET AND ARRAY
    //    let theathreNames = ["","","",""]
    //    let type = ["","","","",""]
    //    let location = ["","","","",""]
    //    let images = ["","","","",""]
    //    var theathre = [Theathre(name: "Екатеринбургский государственный академический театр оперы и балета", type: "Театр оперы и балета", location: "просп. Ленина, 46А, Екатеринбург, Свердловская обл.", theathreImages: "Екатеринбургский государственный академический театр оперы и балета"),
    //    Theathre(name: "Екатеринбургский музыкально-драматический театр", type: "Музыкально-драматический театр", location: "просп. Ленина, 48 А, Екатеринбург, Свердловская обл.", theathreImages: "Екатеринбургский музыкально-драматический театр Сцена"),
    //    Theathre(name: "Коляда-Театр", type: "Частный театр", location: "просп. Ленина, 97, Екатеринбург, Свердловская обл.", theathreImages: "Коляда-Театр"),
    //    Theathre(name: "Волхонка", type: "Драматический театр", location: "ул. Малышева, 21/1, Екатеринбург, Свердловская обл.", theathreImages: "Волхонка"),
    //    Theathre(name: "Камерный Театр Объединенного Музея Писателей Урала", type: "Камерный театр", location: "ул. Пролетарская, 18, Екатеринбург, Свердловская обл.", theathreImages: "Камерный Театр Объединенного Музея Писателей Урала")]
    var theathres: Results<Theathre>!
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        theathres = realm.objects(Theathre.self)
        
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.estimatedRowHeight = 85
    }
    
    
    // MARK: - TABLE METHOD NIMBER OF SECTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    // MARK: - TABLE METHOD NUMBER OF ROWS IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return theathres.isEmpty ? 0 : theathres.count
    }
    
    
    // MARK: - TABLE METHOD HEIGHT FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    // MARK: - TABLE METHOD CELL FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        let theathres = self.theathres[indexPath.row]
        
        cell.nameLabel.text = theathres.name
        cell.typeLabel.text = theathres.type
        cell.locationLabel.text = theathres.location
        cell.images.image = UIImage(data: theathres.imageData!)
        cell.images.layer.cornerRadius = 29.5
        cell.images.clipsToBounds = true
        
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        
        return cell
    }
    
    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - TABLE METHOD TRAILING SWIPE ACTIONS CONFIGURATION FOR ROW AT
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let theathre = theathres[indexPath.row]
        let delete = UIContextualAction(style: .normal, title: "Удалить", handler: {_,_,_  in
            StorageManager.deleteObject(theathre)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let swipe = UISwipeActionsConfiguration(actions: [delete])

        delete.backgroundColor = .red
        
        return swipe
    }
    
    
    // MARK: - UNWIND SEGUE
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let theathreVC = segue.source as? NewTableViewController else { return }
        theathreVC.saveNewTheathre()
        
        tableView.reloadData()
    }
    
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
