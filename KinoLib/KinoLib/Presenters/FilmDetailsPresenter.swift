//
//  FilmDetailsPresenter.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

import Firebase
import FirebaseFirestore


/*protocol FilmDetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewController, film: Film)
    
    func showDetails()
    func toggleFavoriteStatus()
}*/

class FilmDetailsPresenter/*: FilmDetailsPresenterProtocol*/ {
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
            posterPath: film.posterPath ?? "",
            title: film.title ?? "",
            genres: [],
            voteAverage: film.voteAverage ?? 0,
            voteCount: film.voteCount ?? 0,
            favorite: false,
            overview: film.overview ?? ""
        )
    }
    
    func showDetails() {
        // view.nameLabel.text = film.name
        //view.plotLabel.text = film.plot
//        film.genres.forEach { genre in
//            view.genresLable.text?.append(genre)
//        }
    }
    
    func isFavorite(_ callback: @escaping(Bool) -> ()) {
        guard let user = Auth.auth().currentUser else {
            callback(false)
            return
        }
        
        DB.getFavoritesArr(user.uid) {
            (film_ids, err) in
            
            if (err != nil) {
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
