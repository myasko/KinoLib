//
//  ListPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 08.12.2021.
//

import Foundation

protocol ListPresenterProtocol{
    var output: ListPresenterOutput? { get set }
    var films: [Film] {get set}
    var genres: [Int:String]! {get set}
    var tag: Int! {get}
    func getFilms()
    var totalPages: Int! {get set}
}

protocol ListPresenterOutput: AnyObject {
    func success()
    func failure()
}
class ListPresenter: ListPresenterProtocol, FilmManagerOutput{
    func success<T>(result: T, iter: Int) {
        if let result = result as? Films{
            page += 1
            loadNow = false
            films.append(contentsOf: result.results!)
            if tag == 0{
                self.films.sort {
                    $0.releaseDate ?? "" < $1.releaseDate ?? ""
                }
            }
            self.output?.success()
        }
    }
    
    func failure(error: Error, iter: Int) {
        loadNow = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.output?.failure()
            }
    }
    var totalPages: Int!
    var page = 2
    var loadNow = false
    var filmManager: FilmManagerProtocol = FilmManager.shared
    weak var view: ListViewControllerProtocol!
    weak var output: ListPresenterOutput?
    var films = [Film]()
    var genres: [Int:String]!
    let tag: Int!
    
    let operation = OperationQueue()
    
    init(view: ListViewControllerProtocol, tag: Int) {
        self.view = view
        self.tag = tag
        operation.maxConcurrentOperationCount = 1
    }
    
    func getFilms() {
        operation.addOperation {
            if self.loadNow == false && self.page <= self.totalPages{

                self.loadNow = true
                let url: String
                switch self.tag{
                case 0:
                    url="https://api.themoviedb.org/3/movie/upcoming?language=ru&page=\(self.page)&region=ru"
                case 1:
                    url = "https://api.themoviedb.org/3/movie/now_playing?language=ru&page=\(self.page)&region=ru"
                case 2:
                    url = "https://api.themoviedb.org/3/movie/popular?language=ru&page=\(self.page)&region=ru"
                case 3:
                    url = "https://api.themoviedb.org/3/movie/top_rated?language=ru&page=\(self.page)&region=ru"
                default:
                    url = ""
                }
            
                self.filmManager.load(ofType: Films.self, url: url, iter: 0)
                self.filmManager.output = self
            }
        }
        
    }
}
