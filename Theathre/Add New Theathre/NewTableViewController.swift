//
//  NewTableViewController.swift
//  Theathre
//
//  Created by Евгений Сергеевич on 30.10.2020.
//

import UIKit

class NewTableViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var textFields: [UITextField]!
    
    
    // MARK: - VAR,LET AND ARRAY
    
    var imagesIsChange = false
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = .black
        saveButton.isEnabled = false
        
        textFields[0].addTarget(self, action: #selector(textFieldsChange), for: .editingChanged)
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
    
    
    // MARK: - METHOD SAVE NEW THEATHRE
    func saveNewTheathre() {

        var image: UIImage!
        
        if imagesIsChange{
            image = imagesView.image
        } else {
          image = #imageLiteral(resourceName: "default image ")
        }
        
        let imageData = image.pngData()
        let newTheathres = Theathre(name: textFields[0].text!, location: textFields[1].text, type: textFields[2].text, imageData: imageData)
        StorageManager.saveObject(newTheathres)
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
    
    
    // MARK: - METHOD CANCEL TO MAIN SCREEN
    @IBAction func cancelToMainScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

