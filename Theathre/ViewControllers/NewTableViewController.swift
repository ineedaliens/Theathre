//
//  NewTableViewController.swift
//  Theathre
//
//  Created by Евгений Сергеевич on 30.10.2020.
//

import UIKit
import Cosmos

class NewTableViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var textFields: [UITextField]!
//    @IBOutlet weak var ratingControll: RatingControll!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var mapButton: UIButton!
    
    
    // MARK: - VAR,LET AND ARRAY
    var currentTheathre: Theathre!
    var imagesIsChange = false
    var currentRating =  0.0
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorColor = .black
        saveButton.isEnabled = false
        
        setupEditScreen()
        
        textFields[0].addTarget(self, action: #selector(textFieldsChange), for: .editingChanged)
        
        cosmosView.settings.fillMode = .half
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
        mapButton.layer.borderWidth = 1
    }
    
    
    // MARK: - METHOD IMAGE PICKER CONTROLLER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagesView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imagesView.contentMode = .scaleAspectFill
        imagesView.clipsToBounds = true
        imagesIsChange = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photolibraryIcon = #imageLiteral(resourceName: "folder")
            let ac =  UIAlertController(title: nil, message: "Выбери действие", preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default, handler: {_ in
                self.chooseImagePicker(sourse: .camera)
            })
            camera.setValue(cameraIcon, forKey: "image") // add icon in action sheet for key
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // set titleTextAligment.left
            let photolibrary = UIAlertAction(title: "Галерея", style: .default, handler: {_ in
                self.chooseImagePicker(sourse: .photoLibrary)
            })
            photolibrary.setValue(photolibraryIcon, forKey: "image") // add icon in action sheet for key
            photolibrary.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // set titleTextAligment.left
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            ac.addAction(camera)
            ac.addAction(photolibrary)
            ac.addAction(cancel)
            self.present(ac, animated: true, completion: nil)
        } else {
            view.endEditing(true)
        }
    }
    
    
    // MARK: - METHOD PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        guard let identifier = segue.identifier, let mapVC = segue.destination as? MapViewController else { return }
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        if identifier == "showMap" {
            mapVC.theathre.name = textFields[0].text!
            mapVC.theathre.location = textFields[1].text
            mapVC.theathre.type = textFields[2].text
            mapVC.theathre.imageData = imagesView.image?.pngData()
        }
    }
    
    
    
    // MARK: - METHOD SAVE NEW THEATHRE
    func saveTheathre() {
        
        let image = imagesIsChange ? imagesView.image : #imageLiteral(resourceName: "default image ")
        
        let imageData = image!.pngData()
        let newTheathres = Theathre(name: textFields[0].text!, location: textFields[1].text, type: textFields[2].text, imageData: imageData, rating: currentRating)
        if currentTheathre != nil {
            try! realm.write {
                currentTheathre?.name = newTheathres.name
                currentTheathre?.location = newTheathres.location
                currentTheathre?.type = newTheathres.type
                currentTheathre?.imageData = newTheathres.imageData
                currentTheathre.rating = newTheathres.rating
            }
            } else {
                StorageManager.saveObject(newTheathres)
        }
    
    }
    
    // MARK: - METHOD CHOOSE IMAGE PICKER
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - METHOD SETUP EDIT SCREEN
    private func setupEditScreen() {
        if currentTheathre != nil {
            setupNavigationBar()
            imagesIsChange = true
            guard let data = currentTheathre?.imageData, let image = UIImage(data: data) else { return }
            imagesView.image = image
            imagesView.contentMode = .scaleAspectFill
            textFields[0].text = currentTheathre?.name
            textFields[1].text = currentTheathre?.location
            textFields[2].text = currentTheathre?.type
            cosmosView.rating = currentTheathre.rating
        }
    }
    
    
    // MARK: - METHOD SETUP NAVIGATION BAR
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = .black
        }
        navigationItem.leftBarButtonItem = nil
        title = currentTheathre?.name
        saveButton.isEnabled = true
    }
    
    
    // MARK: - METHOD CANCEL TO MAIN SCREEN
    @IBAction func cancelToMainScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToAddNewTheathre(segue: UIStoryboardSegue) {
        
    }
    
}


// MARK: - EXTENSION NEW TABLE VIEW CONTROLLER
extension NewTableViewController: UITextFieldDelegate {
    
    
    // MARK: - METHOD HIDE KEYBOARD WHEN DONE BUTTON PRESSED
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: - @OBJC METHOD TEXT FIELDS CHANGE
    @objc private func textFieldsChange() {
        if textFields[0].text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}


// MARK: - EXTENSION NEW TABLE VIEW CONTROLLER
extension NewTableViewController: MapViewControllerDelegate {
    func getAddress(_ address: String?) {
        textFields[1].text = address
    }
    
    
}
