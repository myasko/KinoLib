//
//  ListPresenter.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 08.12.2021.
//

import Foundation

protocol ListPresenterProtocol{
    var films: [Film]! {get set}
    var genres: [Int:String]! {get set}
    var tag: Int! {get}
}

final class ListPresenter: ListPresenterProtocol{
    
    private var filmManager: FilmManagerProtocol = FilmManager.shared
    weak var view: ListViewControllerProtocol!
    weak var output: MainPresenterOutput?
    var films: [Film]!
    var genres: [Int:String]!
    let tag: Int!
    
    init(view: ListViewControllerProtocol, tag: Int) {
        self.view = view
        self.tag = tag
    }
    
}
