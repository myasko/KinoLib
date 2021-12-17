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
    var film: FilmDetails!
    
    required init(view: DetailsViewController, film: Film, genres: [Int:String]) {
        self.view = view
        self.film = self.createFilmDetails(film, genres)
    }
    
    private func createFilmDetails(_ film: Film, _ genres: [Int:String]) -> FilmDetails {
        var genresArr: [String] = []
        var amount = genres.count
        if (amount > 5) {
            amount = 5
        }
        
        for (_, genre) in genres {
            genresArr.append(genre)
            amount -= 1
            if (amount == 0) {
                break
            }
        }
        
        return FilmDetails(
            id: film.id,
            posterPath: film.posterPath ?? "",
            title: film.title ?? "",
            genres: genresArr,
            voteAverage: film.voteAverage ?? 0,
            voteCount: film.voteCount ?? 0,
            overview: film.overview ?? ""
        )
    }
    
    func getFilmDetails() -> FilmDetails {
        return self.film
    }
    
    func isFavorite(_ callback: @escaping(Bool) -> ()) {
        FirestoreManager.isFavoriteFilm(filmId: self.film.id) {
            favorite, err in
            
            if (err != nil) {
                callback(false)
                return
            }
            
            self.film.favorite = favorite
            callback(favorite)
        }
    }
    
    func toggleFavoriteStatus(_ callback: @escaping(Bool?, Error?) -> ()) {
        guard let favorite = self.film.favorite else {
            print("You need to call isFavorite first!")
            return
        }
        
        if favorite {
            FirestoreManager.removeFavoriteFilm(filmId: self.film.id) {
                err in
                
                if (err == nil) {
                    self.film.favorite = !favorite
                }
                
                callback(self.film.favorite, err)
            }
        } else {
            FirestoreManager.addFavoriteFilm(film: FilmFavorite(
                id: self.film.id,
                title: self.film.title,
                posterUrl: Settings.POSTER_BASE_URL + self.film.posterPath
            )) {
                err in
                
                if (err == nil) {
                    self.film.favorite = !favorite
                }
                
                callback(self.film.favorite, err)
            }
        }
    }
    
}
