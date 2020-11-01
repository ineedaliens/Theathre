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
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
