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
    var filmFavorites: [FilmFavorite] { get set }
    
    func getFilms()
    
    func loadFilms(callback: @escaping(Error?) -> ())
}

class FavoritesPresenter: FilmManagerOutput, FavoritesPresenterProtocol {
    var films = [Film]()
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
            films.append(result)
            self.output?.success()
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
    
    func getFilms() {
        for film in filmFavorites {
            let url = "https://api.themoviedb.org/3/movie/\(film.id)?language=ru"
            self.filmManager.load(ofType: Film.self, url: url, iter: 0)
            self.filmManager.output = self
        }
    }
}
