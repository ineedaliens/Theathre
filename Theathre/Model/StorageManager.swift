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
    
    static func saveObject(_ theathre: Theathre) {
        try! realm.write {
            realm.add(theathre)
        }
    }
    
    
    // MARK: - TABLE METHOD DID SELECT ROW AT INDEX PATH
    static func deleteObject (_ theathre: Theathre) {
        try! realm.write {
            realm.delete(theathre)
        }
    }
}
