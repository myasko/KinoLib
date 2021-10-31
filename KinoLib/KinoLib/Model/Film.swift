//
//  Film.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

struct Film: Codable {
    let title: String
    let year: String
    let image: String
    let rank: String?
    let genres: String?
    let release: String?
}
