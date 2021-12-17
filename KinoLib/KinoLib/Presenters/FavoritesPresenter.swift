//
//  FavoritesPresenter.swift
//  KinoLib
//
//  Created by Георгий Бутров on 17.12.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol FavoritesPresenterOutput: AnyObject {
    func success()
    func failure()
}

protocol FavoritesPresenterProtocol{
    var output: FavoritesPresenterOutput? { get set }
    var films: [Film] {get set}
    var genres: [Int:String] {get set}
    var filmFavorites: [FilmFavorite] { get set }
    
    func getGenres()
    func getFilms()
    
    func loadFilms(callback: @escaping(Error?) -> ())
}

class FavoritesPresenter: FilmManagerOutput, FavoritesPresenterProtocol {
    var films: [Film] = []
    var genres: [Int:String] = [:]
    var filmFavorites: [FilmFavorite] = []
    
    weak var view: FavoritesViewController!
    weak var output:  FavoritesPresenterOutput?
    var filmManager: FilmManagerProtocol = FilmManager.shared
    
    func loadFilms(callback: @escaping(Error?) -> ()) {
        FirestoreManager.getFavoriteFilms() {
            filmsArr, err in
            
            if (err != nil) {
                callback(err)
                return
            }
            
            self.filmFavorites = filmsArr
            
            callback(err)
        }
    }
    
    
    func success<T>(result: T, iter: Int) {
        if let result = result as? Film {
            films[iter] = result
            self.output?.success()
        } else if let result = result as? [Int:String] {
            genres = result
        }
    }
    func failure(error: Error, iter: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.output?.failure()
        }
    }
    
    init(view: FavoritesViewController) {
        self.view = view
    }
    
    func getGenres() {
        let url: String = "https://api.themoviedb.org/3/genre/movie/list?language=ru&region=ru"
        filmManager.load(ofType: Genres.self, url: url, iter: -1)
        filmManager.output = self
    }
    
    func getFilms() {
        films = []
        for i in 0...filmFavorites.count {
            films.append(Film.init(
                id: 0,
                title: "",
                releaseDate: "",
                posterPath: "",
                overview: "",
                genreIds: [],
                popularity: 0,
                voteAverage: 0,
                voteCount: 0,
                genres: []
            ))
        }
        
        var iter = 0
        for film in filmFavorites {
            // exmp: https://api.themoviedb.org/3/movie/299536?language=ru&region=ru
            let url = "https://api.themoviedb.org/3/movie/\(film.id)?language=ru&region=ru"
            self.filmManager.load(ofType: Film.self, url: url, iter: iter)
            iter += 1
            self.filmManager.output = self
        }
    }
}
