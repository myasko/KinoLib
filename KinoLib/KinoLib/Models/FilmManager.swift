//
//  FilmModel.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 11.11.2021.
//

import Foundation

protocol FilmManagerProtocol {
    var output: FilmManagerOutput? { get set }
    var networkManager: NetworkManagerProtocol! { get }
    func load<T:Codable>(ofType: T.Type, url: String, iter: Int)
}

protocol FilmManagerOutput: AnyObject {
    func success<T>(result: T, iter: Int)
    func failure(error: Error, iter: Int)
    
}

class FilmManager: FilmManagerProtocol {
    static let shared: FilmManagerProtocol = FilmManager(networkManager: NetworkManager())
    
    let networkManager: NetworkManagerProtocol!
    weak var output: FilmManagerOutput?
    
    private init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func load<T:Codable>(ofType: T.Type, url: String, iter: Int = 0) {
        self.networkManager.get(ofType: T.self, url: url){[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let items):
                if let genresArray = items as? Genres {
                    var genres = [Int:String]()
                    genresArray.genres!.forEach(){
//                        print($0)
                        genres[$0.id] = $0.name
                    }
                    self.output?.success(result: genres, iter: iter)
                }
                else{
                    self.output?.success(result: items, iter: iter)
//                    self.
                }
            case .failure(let error):
                self.output?.failure(error: error, iter: iter)
            }
        }
    }
}

