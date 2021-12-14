//
//  FavoriteMovie.swift
//  KinoLib
//
//  Created by Максим on 18.11.2021.
//

import Foundation

struct FavoriteMovie {
    let identifier = UUID().uuidString
    let title: String
    let genre: String
    let isFavourite: Bool
    let imageUrl: URL?
}
