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
    func getFilms()
    var filmsCount: Int {get set}
    var filmsId: [FilmFavorite] {get set}
}

class FavoritesPresenter: FilmManagerOutput, FavoritesPresenterProtocol {
    
    var filmsId: [FilmFavorite] = {
        var arr: [FilmFavorite] = []
        
            FirestoreManager.getFavoriteFilms() {
                filmsArr, err in
                if (err != nil) {
                    print(err)
                    return
                }
                arr = filmsArr
            }
        return arr
    }()
    
    var films = [Film]()
    var filmsCount: Int = 0
    weak var view: FavoritesViewController!
    weak var output:  FavoritesPresenterOutput?
    var filmManager: FilmManagerProtocol = FilmManager.shared
    
    
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
        for film in filmsId {
            let url = "https://api.themoviedb.org/3/movie/\(film)?language=ru"
            self.filmManager.load(ofType: Film.self, url: url, iter: 0)
            self.filmManager.output = self
        }
    }
    
}
