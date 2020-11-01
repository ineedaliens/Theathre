//
//  StorageManager.swift
//  Theathre
//
//  Created by Евгений on 01.11.2020.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ theathre: Theathre) {
        try! realm.write {
            realm.add(theathre)
        }
    }
}
