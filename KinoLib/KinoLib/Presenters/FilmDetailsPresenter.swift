//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

protocol FilmDetailsPresenterProtocol: AnyObject {
    func showDetsils()
    func toggleFavoriteStatus()
    var film: Film {get set}
    var isFavorite: Bool { get set }
    var genres: [Int:String] {get set}
}

final class FilmDetailsPresenter: FilmDetailsPresenterProtocol {
    let view: FilmDetailsViewController!
    let user: User = User(login: "wolf", favoriteFilms: [""])
    var film: Film = Film(id: 0, title: "", releaseDate: "", posterPath: "", overview: "", genreIds: [], popularity: 0, voteAverage: 0)
    var genres: [Int:String] = [Int:String] ()
    
    init(view: FilmDetailsViewController) {
        self.view = view
    }
    
    func showDetsils() {
        //view.nameLabel.text = film.name
        view.plotLabel.text = film.overview
        film.genreIds.forEach { genre in
            view.genresLable.text?.append(genres[genre]!)
        }
    }
    
    var isFavorite: Bool {
        get {
            DataManager.shared.getFavoriteStatus(for: film.title)
        } set {
            DataManager.shared.setFavoriteStatus(for: film.title, with: newValue)
        }
    }
    
    func toggleFavoriteStatus() {
        isFavorite.toggle()
    }
    
}
