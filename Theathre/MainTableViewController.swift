//
//  MainTableViewController.swift
//  Theathre
//
//  Created by Евгений on 26.10.2020.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    
    // MARK: - VAR,LET AND ARRAY
    let theathreNames = ["Екатеринбургский государственный академический театр оперы и балета","Екатеринбургский музыкально-драматический театр Сцена","Коляда-Театр","Волхонка","Камерный Театр Объединенного Музея Писателей Урала"]
    let type = ["Театр оперы и балета","Музыкально-драматический театр","Частный театр","Драматический театр","Камерный театр"]
    let location = ["просп. Ленина, 46А, Екатеринбург, Свердловская обл., 620075","просп. Ленина, 48 А, Екатеринбург, Свердловская обл., 620100","просп. Ленина, 97, Екатеринбург, Свердловская обл., 620062","ул. Малышева, 21/1, Екатеринбург, Свердловская обл., 620014","ул. Пролетарская, 18, Екатеринбург, Свердловская обл., 620075"]
    let images = ["Екатеринбургский государственный академический театр оперы и балета","Екатеринбургский музыкально-драматический театр Сцена","Коляда-Театр","Волхонка","Камерный Театр Объединенного Музея Писателей Урала"]
    
    
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
      
        return theathreNames.count
    }

    
    // MARK: - TABLE METHOD HEIGHT FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    // MARK: - TABLE METHOD CELL FOR ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        cell.nameLabel.text = theathreNames[indexPath.row]
        cell.typeLabel.text = type[indexPath.row]
        cell.locationLabel.text = location[indexPath.row]
        cell.images.image = UIImage(named: images[indexPath.row])
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
