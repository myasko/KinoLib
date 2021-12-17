//
//  Firestore.swift
//  KinoLib
//
//  Created by KoroLion on 15.12.2021.
//

import Foundation
import FirebaseFirestore

class DB {
    static let dbRef = Firestore.firestore()
    
    static let favoriteFilmsRef = dbRef.collection("favorite_films")
    
    static func getFavoritesArr(_ uid: String, _ callback: @escaping([Int], String?) -> ()) {
        self.favoriteFilmsRef.document("\(uid)").getDocument {
            (document, error) in
            
            if (error != nil) {
                print(error)
                callback([], error?.localizedDescription)
                return
            }
            
            if let document = document, document.exists {
                guard let id_list = document.get("id_list") as? [Int] else {
                    callback([], "Некорректные данные в БД!")
                    return
                }
                
                callback(id_list, nil)
            } else {
                callback([], nil)
            }
        }
    }
    
    static func toggleFavorite(_ uid: String, _ filmId: Int, _ callback: @escaping(Bool, String?) -> ()) {
        self.getFavoritesArr(uid) {
            (id_list, err) in
                
            if (id_list.contains(filmId)) {
                self.favoriteFilmsRef.document("\(uid)").updateData([
                    "id_list": FieldValue.arrayRemove([filmId]),
                ]) {
                    err in
                    
                    if (err != nil) {
                        callback(true, err?.localizedDescription)
                    } else {
                        callback(false, nil)
                    }
                }
            } else {
                self.favoriteFilmsRef.document("\(uid)").updateData([
                    "id_list": FieldValue.arrayUnion([filmId]),
                ]) {
                    err in
                    
                    if (err != nil) {
                        self.favoriteFilmsRef.document("\(uid)").setData([
                            "id_list": [filmId],
                        ]) {
                            err in
                            
                            if (err != nil) {
                                callback(false, err?.localizedDescription)
                            } else {
                                callback(true, nil)
                            }
                        }
                    } else {
                        callback(true, nil)
                    }
                }
            }
        }
    }
}
