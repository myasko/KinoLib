//
//  MainPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 26.10.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewControllerProtocol, networkManager: NetworkManagerProtocol)
    func applyFilter()
    func getFilms()
    var films: [Film]? {get set}
}


final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewControllerProtocol!
    let networkManager: NetworkManagerProtocol!
    var films: [Film]?
    init(view: MainViewControllerProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func applyFilter (){
        
    }
    
    func getFilms() {
        networkManager.getFilms(ofType: Films.self){[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(let films):
                    self.films = films?.films
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
