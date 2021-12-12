//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

protocol FilmDetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewController, film: Film)
    
    func showDetails()
    func toggleFavoriteStatus()
    var isFavorite: Bool { get set }
}

class FilmDetailsPresenter: FilmDetailsPresenterProtocol {
    let view: DetailsViewController!
    let film: Film
    
    required init(view: DetailsViewController, film: Film) {
        self.view = view
        self.film = film
    }
    
    func getFilmDetails() -> FilmDetails {
        /*let genresArray = items as? Genres {
            var genres = [Int:String]()
            genresArray.genres!.forEach(){
                print($0)
                genres[$0.id] = $0.name
            }
            self.output?.success(result: genres, iter: iter)
        }*/
        
        return FilmDetails(
            posterPath: film.posterPath!,
            title: film.title!,
            genres: [],
            voteAverage: film.voteAverage!,
            voteCount: film.voteCount!,
            favorite: false,
            overview: film.overview!
        )
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
