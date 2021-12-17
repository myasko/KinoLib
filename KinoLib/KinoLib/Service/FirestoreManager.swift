//
//  Firestore.swift
//  KinoLib
//
//  Created by KoroLion on 15.12.2021.
//

import Firebase
import FirebaseFirestore

class FirestoreManager {
    static let dbRef = Firestore.firestore()
    
    static let userInfoRef = dbRef.collection("user_info")
    
    static private func getFilmDocumentRef(_ uid: String, _ filmId: Int) -> DocumentReference {
        return userInfoRef.document(uid).collection("favorite_films").document(String(filmId))
    }
    
    static func getFavoriteFilms(callback: @escaping([FilmFavorite], Error?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        userInfoRef.document(user.uid).collection("favorite_films").getDocuments() {
            snapshot, err in
            
            if (err != nil) {
                callback([], err)
                return
            }
            
            var films: [FilmFavorite] = []
            for document in snapshot!.documents {
                let data = document.data()
                
                films.append(FilmFavorite(
                    id: data["id"] as? Int ?? 0,
                    title: data["title"] as? String ?? "",
                    posterUrl: data["posterUrl"] as? String ?? ""
                ))
            }
            
            callback(films, err)
        }
    }
    
    static func isFavoriteFilm(filmId: Int, callback: @escaping(Bool, Error?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        getFilmDocumentRef(user.uid, filmId).getDocument() {
            document, err in
            
            if (err != nil) {
                callback(false, err)
                return
            }
            
            if let document = document, document.exists {
                callback(true, nil)
            } else {
                callback(false, nil)
            }
        }
    }
    
    static func addFavoriteFilm(film: FilmFavorite, callback: @escaping(Error?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        getFilmDocumentRef(user.uid, film.id).setData([
            "id": film.id,
            "title": film.title,
            "posterUrl": film.posterUrl
        ]) {
            err in
            
            callback(err)
        }
    }
    
    static func removeFavoriteFilm(filmId: Int, callback: @escaping(Error?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        getFilmDocumentRef(user.uid, filmId).delete() {
            err in
            
            callback(err)
        }
    }
}
