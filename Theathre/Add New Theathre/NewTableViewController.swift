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
    
    
    // MARK: - VAR,LET AND ARRAY
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.6672332883, blue: 0.7453075051, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = .black
    }

    
    // MARK: - METHOD IMAGE PICKER CONTROLLER
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             imagesView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
             imagesView.contentMode = .scaleAspectFill
             imagesView.clipsToBounds = true
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
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAligment") // set titleTextAligment.left
            let photolibrary = UIAlertAction(title: "Галерея", style: .default, handler: {_ in
                self.chooseImagePicker(sourse: .photoLibrary)
            })
            photolibrary.setValue(photolibraryIcon, forKey: "image") // add icon in action sheet for key
            photolibrary.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAligment") // set titleTextAligment.left
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            ac.addAction(camera)
            ac.addAction(photolibrary)
            ac.addAction(cancel)
            self.present(ac, animated: true, completion: nil)
        } else {
            view.endEditing(true)
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
}


// MARK: - EXTENSION NEW TABLE VIEW CONTROLLER
extension NewTableViewController: UITextFieldDelegate {
 
    
    // MARK: - METHOD HIDE KEYBOARD WHEN DONE BUTTON PRESSED
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

