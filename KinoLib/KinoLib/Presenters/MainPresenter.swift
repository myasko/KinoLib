//
//  MainPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 26.10.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var output: MainPresenterOutput? { get set }
    func loadData ()
    var films: [[Film]?] {get set}
    var genres: [Int:String] {get set}
    func didTapButton(tag: Int)
    var loadIndicator: [Int] {get set}
    var totalPages: [Int] {get set}
}

protocol MainPresenterOutput: AnyObject {
    func success()
    func failure()
}

extension MainPresenter.Url: CaseIterable{

}

final class MainPresenter: MainPresenterProtocol {

    enum Url: String {
        case upcoming = "https://api.themoviedb.org/3/movie/upcoming?language=ru&page=1&region=ru"
        case inCinema = "https://api.themoviedb.org/3/movie/now_playing?language=ru&page=1&region=ru"
        case popularNow = "https://api.themoviedb.org/3/movie/popular?language=ru&page=1&region=ru"
        case bestFilms = "https://api.themoviedb.org/3/movie/top_rated?language=ru&page=1&region=ru"
        case genres = "https://api.themoviedb.org/3/genre/movie/list?language=ru&region=ru"
    }
    var totalPages: [Int] = Array(repeating: 0, count: 4)
    private var filmManager: FilmManagerProtocol = FilmManager.shared
    weak var view: MainViewControllerProtocol!
    weak var output: MainPresenterOutput?
    
    var films: [[Film]?] = Array(repeating: [
        Film.init(
            id: 0,
            title: "",
            releaseDate: "",
            posterPath: "",
            overview: "",
            genreIds: [0],
            popularity: 0,
            voteAverage: 0,
            voteCount: 0,
            genres: []
        )
    ], count: 4)
    
    var loadIndicator: [Int] = Array(repeating: 0, count: 4)
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
    }

    func loadData() {

        self.getGenres()
        for i in 0..<(Url.allCases.count - 1){
            loadIndicator[i] = 0
            self.getFilms(url: Url.allCases[i].rawValue, iter: i)
        }
    }

    func didTapButton(tag: Int){
        view.showVC(tag: tag)
    }
}

extension MainPresenter: FilmManagerOutput{
    func success<T>(result: T, iter: Int) {
        loadIndicator[iter] = 1
        if let result = result as? Films{
            self.films[iter] = result.results
            self.totalPages[iter] = result.totalPages
            if iter == 0{
                if let index = self.films[0]!.firstIndex(where: {$0.releaseDate ?? "" < result.dates!.minimum}) {
                    self.films[0]![index].releaseDate = result.dates!.minimum
                }
                self.films[iter]?.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
            }
            if iter == 0{
                self.output?.success()
            }
        }
        else if let result = result as? [Int:String] {
            genres = result
        }
    }
    
    func failure(error: Error, iter: Int) {
        loadIndicator[iter] = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.output?.failure()
        }
    }
}
