//
//  Theathre.swift
//  Theathre
//
//  Created by Евгений on 31.10.2020.
//

import RealmSwift

class Theathre: Object {
    @objc dynamic var name = ""
    @objc dynamic var type: String?
    @objc dynamic var location: String?
    @objc dynamic var imageData: Data?
    
//    var theathre = [Theathre(name: "", type: "Театр оперы и балета", location: "просп. Ленина, 46А, Екатеринбург, Свердловская обл.", theathreImages: "Екатеринбургский государственный академический театр оперы и балета"),
//       Theathre(name: "", type: "Музыкально-драматический театр", location: "просп. Ленина, 48 А, Екатеринбург, Свердловская обл.", theathreImages: "Екатеринбургский музыкально-драматический театр Сцена"),
   //    Theathre(name: "", type: "Частный театр", location: "просп. Ленина, 97, Екатеринбург, Свердловская обл.", theathreImages: "Коляда-Театр"),
   //    Theathre(name: "", type: "Драматический театр", location: "ул. Малышева, 21/1, Екатеринбург, Свердловская обл.", theathreImages: "Волхонка"),
   //    Theathre(name: "", type: "Камерный театр", location: "ул. Пролетарская, 18, Екатеринбург, Свердловская обл.", theathreImages: "Камерный Театр Объединенного Музея Писателей Урала")]
    let theathreNames = ["Екатеринбургский государственный академический театр оперы и балета","Екатеринбургский музыкально-драматический театр","Коляда-Театр","Волхонка","Камерный Театр Объединенного Музея Писателей Урала"]
    
    func saveTheathres() {
        for theathre in theathreNames {
            
            let image = UIImage(named: theathre)
            guard let imageData = image?.pngData() else { return }
            
            let newTheathre = Theathre()
            
            newTheathre.name = theathre
            newTheathre.location = "Екатеринбург"
            newTheathre.type = "Театр драмы и балета"
            newTheathre.imageData = imageData
            
            StorageManager.saveObject(newTheathre)
        }
    }
}
