//
//  StorageManager.swift
//  TrackList
//
//  Created by Евгений on 20.12.2020.
//


import RealmSwift

 let realm = try! Realm()

class StorageManager {
    static func saveObject(_ tracklist: TrackList) {
        try! realm.write {
            realm.add(tracklist)
        }
    }
    
    static func deleteObject( tracklist: TrackList) {
        try! realm.write {
            realm.delete(tracklist)
        }
    }
}
