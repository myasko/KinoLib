//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

protocol FilmDetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewController/*, user: User, film: FilmDetails*/)
    
    func showDetails()
    func toggleFavoriteStatus()
    var isFavorite: Bool { get set }
}

class FilmDetailsPresenter: FilmDetailsPresenterProtocol {
    
    let view: DetailsViewController!
    //let user: User
    // let film: FilmDetails
    
    required init(view: DetailsViewController) {
        self.view = view
        //self.user = user
        // self.film = film
    }
    
    func showDetails() {
        // view.nameLabel.text = film.name
        //view.plotLabel.text = film.plot
//        film.genres.forEach { genre in
//            view.genresLable.text?.append(genre)
//        }
    }
    
    var isFavorite: Bool {
        get {
            false
            // DataManager.shared.getFavoriteStatus(for: film.name)
        } set {
            // DataManager.shared.setFavoriteStatus(for: film.name, with: newValue)
        }
    }
    
    func toggleFavoriteStatus() {
        isFavorite.toggle()
    }
    
}
