//
//  TableModel.swift
//  KinoLib
//
//  Created by Максим on 13.12.2021.
//

import Foundation

protocol TableModelDescription: AnyObject {
    var output: TableViewControllerInput? { get set }
    
    func loadFavoriteMovies()
}

final class TableModel: TableModelDescription {
    private var favoriteMovieManager: FavoriteMovieManagerProtocol = FavoriteMovieManager.shared
    
    weak var output: TableViewControllerInput?
    
    func loadFavoriteMovies() {
        favoriteMovieManager.loadFavoriteMovies()
        favoriteMovieManager.output = self
    }
}

extension TableModel: FavoriteMovieManagerOutput {
    func didReceive(_ favoriteMovies: [FavoriteMovie]) {
        output?.didReceive(favoriteMovies)
    }
}
