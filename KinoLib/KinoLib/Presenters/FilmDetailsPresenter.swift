//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

import Firebase
import FirebaseFirestore


class FilmDetailsPresenter {
    let view: DetailsViewController!
    let film: Film!
    let genres: [Int:String]!
    
    required init(view: DetailsViewController, film: Film, genres: [Int:String]) {
        self.view = view
        self.film = film
        self.genres = genres
    }
    
    func getFilmDetails() -> FilmDetails {
        var genresArr: [String] = []
        var amount = self.genres.count
        if (amount > 5) {
            amount = 5
        }
        
        for (_, genre) in self.genres {
            genresArr.append(genre)
            amount -= 1
            if (amount == 0) {
                break
            }
        }
        
        return FilmDetails(
            posterPath: film.posterPath ?? "",
            title: film.title ?? "",
            genres: genresArr,
            voteAverage: film.voteAverage ?? 0,
            voteCount: film.voteCount ?? 0,
            favorite: false,
            overview: film.overview ?? ""
        )
    }
    
    func isFavorite(_ callback: @escaping(Bool) -> ()) {
        guard let user = Auth.auth().currentUser else {
            callback(false)
            return
        }
        
        DB.getFavoritesArr(user.uid) {
            (film_ids, err) in
            
            if (err != nil) {
                print(err)
                callback(false)
                return
            }
            
            callback(film_ids.contains(self.film.id))
        }
    }
    
    func toggleFavoriteStatus(_ callback: @escaping(Bool, String?) -> ()) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        DB.toggleFavorite(user.uid, self.film.id, callback)
    }
    
}
