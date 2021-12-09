//
//  MainPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 26.10.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
//    func getFilms(url: String)
//    func getGenres ()
    var output: MainPresenterOutput? { get set }
    func loadData ()
    var films: [[Film]?] {get set}
    var genres: [Int:String] {get set}
}

protocol MainPresenterOutput: AnyObject {
    func success()
    func failure()
}

extension MainPresenter.Url: CaseIterable{
    
}

final class MainPresenter: MainPresenterProtocol {
    
    enum Url: String {
        case upcoming = "https://api.themoviedb.org/3/movie/upcoming?api_key=3eb9f76abfcf6dfa4ac87f43b1f2bdb9&language=ru&page=1&region=ru"
        case inCinema = "https://api.themoviedb.org/3/movie/now_playing?api_key=3eb9f76abfcf6dfa4ac87f43b1f2bdb9&language=ru&page=1&region=ru"
        case popularNow = "https://api.themoviedb.org/3/movie/popular?api_key=3eb9f76abfcf6dfa4ac87f43b1f2bdb9&language=ru&page=1&region=ru"
        case bestFilms = "https://api.themoviedb.org/3/movie/top_rated?api_key=3eb9f76abfcf6dfa4ac87f43b1f2bdb9&language=ru&page=1&region=ru"
        case genres = "https://api.themoviedb.org/3/genre/movie/list?api_key=3eb9f76abfcf6dfa4ac87f43b1f2bdb9&language=ru"
//        static let allValues = [upcoming, inCinema, popularNow, bestFilms, genres]
    }
    
    private var filmManager: FilmManagerProtocol = FilmManager.shared
    weak var view: MainViewControllerProtocol!
    weak var output: MainPresenterOutput?
    var films: [[Film]?] = Array(repeating: [Film.init(id: 0, title: "", releaseDate: "", posterPath: "", overview: "", genreIds: [0], popularity: 0, voteAverage: 0, voteCount: 0)], count: 4)
//    var films = [[Film]?]()
    var genres = [Int:String]()
    init(view: MainViewControllerProtocol) {
        self.view = view
    }
    
    func getFilms(url: String, iter: Int) {
        filmManager.load(ofType: Films.self, url: url, iter: iter)
        filmManager.output = self
        
    }
    
    func getGenres() {
        filmManager.load(ofType: Genres.self, url: Url.genres.rawValue, iter: 0)
        filmManager.output = self
//        print("[DEBUG] \(Url.allCases[3].rawValue)")
    }
    
    func loadData() {
        self.getGenres()
        for i in 0..<(Url.allCases.count - 1){
            self.getFilms(url: Url.allCases[i].rawValue, iter: i)
        }
    }
}

extension MainPresenter: FilmManagerOutput{
    
    func success<T>(result: T, iter: Int) {
        if let result = result as? Films{
            self.films[iter] = result.results
            if iter == 0{
                self.films[iter]?.sort {
                    $0.releaseDate < $1.releaseDate
                }
            }
            self.output?.success()
            print("Кинцо \(self.films.count)")
            
        }
        else if let result = result as? [Int:String] {
            genres = result
//            print(result)
        }
    }
    func failure(error: Error) {
        self.output?.failure()
        print("Ашибка брат")
        print(error)
    }
}
    
