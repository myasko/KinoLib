//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

protocol FilmDetailsPresenterProtocol: AnyObject {
    init(view: FilmDetailsViewController, user: User, film: Film)
    func showDetsils()
    func toggleFavoriteStatus()
    var isFavorite: Bool { get set }
}

class FilmDetailsPresenter: FilmDetailsPresenterProtocol {
    
    let view: FilmDetailsViewController
    let user: User
    let film: Film
    
    required init(view: FilmDetailsViewController, user: User, film: Film) {
        self.view = view
        self.user = user
        self.film = film
    }
    
    func showDetsils() {
        //view.nameLabel.text = film.name
        //view.plotLabel.text = film.plot
//        film.genres.forEach { genre in
//            view.genresLable.text?.append(genre)
//        }
    }
    
    var isFavorite: Bool {
        get {
            DataManager.shared.getFavoriteStatus(for: film.name)
        } set {
            DataManager.shared.setFavoriteStatus(for: film.name, with: newValue)
        }
    }
    
    func toggleFavoriteStatus() {
        isFavorite.toggle()
    }
    
}
