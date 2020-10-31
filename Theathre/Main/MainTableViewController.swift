//
//  MainTableViewController.swift
//  Theathre
//
//  Created by Евгений on 26.10.2020.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    
    // MARK: - VAR,LET AND ARRAY
//    let theathreNames = ["","","",""]
//    let type = ["","","","",""]
//    let location = ["","","","",""]
//    let images = ["","","","",""]
    let theathre = [Theathre(name: "Екатеринбургский государственный академический театр оперы и балета", type: "Театр оперы и балета", location: "просп. Ленина, 46А, Екатеринбург, Свердловская обл., 620075", images: "Екатеринбургский государственный академический театр оперы и балета"),
    Theathre(name: "Екатеринбургский музыкально-драматический театр Сцена", type: "Музыкально-драматический театр", location: "просп. Ленина, 48 А, Екатеринбург, Свердловская обл., 620100", images: "Екатеринбургский музыкально-драматический театр Сцена"),
    Theathre(name: "Коляда-Театр", type: "Частный театр", location: "просп. Ленина, 97, Екатеринбург, Свердловская обл., 620062", images: "Коляда-Театр"),
    Theathre(name: "Волхонка", type: "Драматический театр", location: "ул. Малышева, 21/1, Екатеринбург, Свердловская обл., 620014", images: "Волхонка"),
    Theathre(name: "Камерный Театр Объединенного Музея Писателей Урала", type: "Камерный театр", location: "ул. Пролетарская, 18, Екатеринбург, Свердловская обл., 620075", images: "Камерный Театр Объединенного Музея Писателей Урала")]
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.estimatedRowHeight = 85
    }

    
    // MARK: - TABLE METHOD NIMBER OF SECTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    
    // MARK: - TABLE METHOD NUMBER OF ROWS IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return theathre.count
    }

    
    // MARK: - TABLE METHOD HEIGHT FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    // MARK: - TABLE METHOD CELL FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.nameLabel.text = theathre[indexPath.row].name
        cell.typeLabel.text = theathre[indexPath.row].type
        cell.locationLabel.text = theathre[indexPath.row].location
        cell.images.image = UIImage(named: theathre[indexPath.row].images)
        cell.images.layer.cornerRadius = 29.5
        cell.images.clipsToBounds = true

        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        
        return cell
    }

    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - PREPARE FOR SEGUE
    @IBAction func backToMain(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
