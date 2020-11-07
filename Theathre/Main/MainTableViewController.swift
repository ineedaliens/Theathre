//
//  MainTableViewController.swift
//  Theathre
//
//  Created by Евгений on 26.10.2020.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var reverseSortingButton: UIBarButtonItem!
    
    
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
    private var theathres: Results<Theathre>!
    private var ascendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredTheathres: Results<Theathre>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        theathres = realm.objects(Theathre.self)
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.estimatedRowHeight = 85
        
        // MARK: - SETUP SEARCH CONTROLLER
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
        
    
    // MARK: - TABLE METHOD NIMBER OF SECTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    // MARK: - TABLE METHOD NUMBER OF ROWS IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTheathres.count
        }
        return theathres.isEmpty ? 0 : theathres.count
    }
    
    
    // MARK: - TABLE METHOD HEIGHT FOR ROW AT INDEX PATH
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    // MARK: - TABLE METHOD CELL FOR ROW AT INDEX PATH
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        var theathres = Theathre()
        if isFiltering {
            theathres = filteredTheathres[indexPath.row]
        } else {
            theathres = self.theathres[indexPath.row]
        }
        
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - TABLE METHOD TRAILING SWIPE ACTIONS CONFIGURATION FOR ROW AT
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let theathre = theathres[indexPath.row]
        let delete = UIContextualAction(style: .normal, title: "Удалить", handler: {_,_,_  in
            StorageManager.deleteObject(theathre)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        delete.backgroundColor = .red
        
        return swipe
    }
    
    
    // MARK: - METHOD SORT SELECTION
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
    sorting()
    }
    
    
    // MARK: - METHOD REVERSE SORTING
    @IBAction func reverseSorting(_ sender: Any ) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverseSortingButton.image = #imageLiteral(resourceName: "icons8-сортировка-по-убыванию-72")
        } else {
            reverseSortingButton.image = #imageLiteral(resourceName: "icons8-сортировка-по-возрастанию-72")
        }
        sorting()
    }
    
    
    // MARK: - PRIVATE METHOD SORTING
    private func sorting() {
            if segmentedControll.selectedSegmentIndex == 0 {
                theathres = theathres.sorted(byKeyPath: "date", ascending: ascendingSorting)
            } else {
                theathres = theathres.sorted(byKeyPath: "name", ascending: ascendingSorting)
            }
        tableView.reloadData()
        }
    
    
    // MARK: - UNWIND SEGUE
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let theathreVC = segue.source as? NewTableViewController else { return }
        theathreVC.saveTheathre()
        
        tableView.reloadData()
    }
    
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let theathre: Theathre
            if isFiltering {
                theathre = filteredTheathres[indexPath.row]
            } else {
                theathre = theathres[indexPath.row]
            }
            let dvc = segue.destination as? NewTableViewController
            dvc?.currentTheathre = theathre
        }
    }
}


// MARK: - EXTENSION FOR MAIN TABLE VIEW CONTROLLER
extension MainTableViewController: UISearchResultsUpdating {
    
    
    // MARK: - EXTENSION METHOD UPDATE SEARCH RESULTS
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    
    // MARK: - EXTENSION METHOD FILTERED CONTENT FOR SEARCH TEXT
    private func filteredContentForSearchText(_ searchText: String) {
        filteredTheathres = theathres.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        tableView.reloadData()
    }
}
