//
//  SearchPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 14.12.2021.
//

import Foundation

protocol SearchPresenterProtocol{
    
    var output: SearchPresenterOutput? { get set }
    var films: [Film] {get set}
    var genres: [Int:String]! {get set}
    func getFilms(query: String, scroll: Bool)
    var totalPages: Int {get set}
}

protocol SearchPresenterOutput: AnyObject {
    func success()
    func failure()
}

class SearchPresenter: SearchPresenterProtocol, FilmManagerOutput{
    
    
    func success<T>(result: T, iter: Int) {
        if let result = result as? Films{
            totalPages = result.totalPages
            page += 1
            loadNow = false
            let film = result.results!.sorted{
                $0.popularity! > $1.popularity!
            }
            films.append(contentsOf: film)
            self.output?.success()
        }
        else if let result = result as? [Int:String] {
            genres = result
//            self.output?.success()
        }
    }
    
    func failure(error: Error, iter: Int) {
        loadNow = false
        if iter != -1{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.output?.failure()
                }
        }
    }
    
    var totalPages = 1
    var page = 1
    var loadNow = false
    var filmManager: FilmManagerProtocol = FilmManager.shared
    weak var view: SearchViewControllerProtocol!
    weak var output: SearchPresenterOutput?
    var films = [Film]()
    var genres: [Int:String]!
    
    init(view: SearchViewControllerProtocol) {
        self.view = view
        getGenres()
    }
    
    func getFilms(query: String, scroll: Bool) {
        if genres == nil {
            self.getGenres()
        }
        if scroll == false{
            page = 1
            totalPages = 1
        }
        if self.loadNow == false && self.page <= self.totalPages{
            guard let query = (query as NSString).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
            self.loadNow = true
            let url: String = "https://api.themoviedb.org/3/search/movie?language=ru&query=\(query)&page=\(page)&include_adult=false&region=ru"
            self.filmManager.load(ofType: Films.self, url: url, iter: 0)
            self.filmManager.output = self
        }
    }
    
    func getGenres() {
        let url: String = "https://api.themoviedb.org/3/genre/movie/list?language=ru-RU"
        filmManager.load(ofType: Genres.self, url: url, iter: -1)
        filmManager.output = self
    }
}
