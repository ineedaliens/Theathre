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


    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - EXTENSION NEW TABLE VIEW CONTROLLER
extension NewTableViewController: UITextFieldDelegate {
 
    
    // MARK: - METHOD HIDE KEYBOARD WHEN DONE BUTTON PRESSED
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
