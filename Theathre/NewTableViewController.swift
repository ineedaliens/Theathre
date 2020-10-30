//
//  NewTableViewController.swift
//  Theathre
//
//  Created by Евгений Сергеевич on 30.10.2020.
//

import UIKit

class NewTableViewController: UITableViewController {

    
    // MARK: - VAR,LET AND ARRAY
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = .black
    }

    // MARK: - TABLE METHOD NUMBER OF SECTION
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    // MARK: - TABLE METHOD NUMBER OF ROWS IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    // MARK: - TABLE METHOD CELL FOR ROW AT
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }

    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
