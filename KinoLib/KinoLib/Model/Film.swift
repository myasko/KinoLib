//
//  Film.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

struct Films: Codable{
    let pagesCount: Int
    let films: [Film]
}

struct Film: Codable {
    let nameRu: String
    let year: String
    let posterUrlPreview: String
    let rating: String
    let genres: [Genre]
    let countries: [Country]
}

struct Genre: Codable {
    let genre: String
}

struct Country: Codable {
    let country: String
}
