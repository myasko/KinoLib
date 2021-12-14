//
//  FavoritesMovies.swift
//  KinoLib
//
//  Created by Максим on 18.11.2021.
//

import Foundation

protocol FavoriteMovieManagerProtocol {
    var output: FavoriteMovieManagerOutput? { get set }
    func loadFavoriteMovies()
}

protocol FavoriteMovieManagerOutput: AnyObject {
    func didReceive(_ favoriteMovies: [FavoriteMovie])
}

class FavoriteMovieManager: FavoriteMovieManagerProtocol {
    
    static let shared: FavoriteMovieManagerProtocol = FavoriteMovieManager()
    
    weak var output: FavoriteMovieManagerOutput?
    
    private init() {}
    
    func loadFavoriteMovies() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let favoriteMovies = [
                FavoriteMovie(title: "Железный человек", genre: "Экшен", isFavourite: true, imageUrl: URL(string: "https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/6cc85a8c-bd9d-4343-bd6d-cf87d583db2b/3840x")),
                FavoriteMovie(title: "Заводной апельсин", genre: "Драма", isFavourite: true, imageUrl: URL(string: "https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/dc63100a-f946-48e1-9f63-e01f1775e4eb/576x")),
                FavoriteMovie(title: "Кадры", genre: "Комедия", isFavourite: true, imageUrl: URL(string: "https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/c8611ca2-3fcf-4a64-8287-f13cebdf23d4/x504")),
                FavoriteMovie(title: "Джобс: Империя соблазна", genre: "Документальный", isFavourite: true, imageUrl: URL(string: "https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/4049df11-e5c6-419b-9cf0-c40227e47371/576x")),
                FavoriteMovie(title: "Веном 2", genre: "Экшен", isFavourite: true, imageUrl: URL(string: "https://avatars.mds.yandex.net/get-kinopoisk-image/4303601/74c3134b-f8a4-4adc-a1b8-b77b13e3bae7/576x")),
            ]
            
            self.output?.didReceive(favoriteMovies)
        }
    }
}
