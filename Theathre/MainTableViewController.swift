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
    let images = ["Екатеринбургский государственный академический театр оперы и балета","катеринбургский музыкально-драматический театр Сцена","Коляда-Театр","Волхонка","Камерный Театр Объединенного Музея Писателей Урала"]
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = theathreNames[indexPath.row]
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds = true

        return cell
    }

    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
