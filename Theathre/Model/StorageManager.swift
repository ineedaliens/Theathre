//
//  StorageManager.swift
//  Theathre
//
//  Created by Евгений on 01.11.2020.
//

import RealmSwift


// MARK: - CONNECT TO REALM
let realm = try! Realm()


// MARK: - CLASS STORAGE MANAGER
class StorageManager {
    
    
    // MARK: - METHOD SAVE OBJECT TO DATABASE
    static func saveObject(_ theathre: Theathre) {
        try! realm.write {
            realm.add(theathre)
        }
    }
    
    
    // MARK: - METHOD DELETE OBJECT FROM DATABASE
    static func deleteObject (_ theathre: Theathre) {
        try! realm.write {
            realm.delete(theathre)
        }
    }
}
