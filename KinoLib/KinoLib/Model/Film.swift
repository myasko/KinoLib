//
//  Film.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

struct Films: Codable{
    let page: Int
    let totalPages: Int
    let results: [Film]?
    let dates: Dates?
}

struct Film: Codable {
    let id: Int
    let title: String?
    var releaseDate: String?
    let posterPath: String?
    let overview: String?
    let genreIds: [Int]?
    let popularity: Double?
    let voteAverage: Double?
}

struct Genres: Codable {
    let genres: [Genre]?
}

struct Genre: Codable {
    let id: Int
    let name: String
}
struct Dates: Codable{
    let maximum: String
    let minimum: String
}
