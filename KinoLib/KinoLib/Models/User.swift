//
//  User.swift
//  KinoLib
//
//  Created by KoroLion on 16.11.2021.
//

import Foundation

struct UserAuth {
    let username: String
    let password: String
}

struct UserSignup {
    let username: String
    let password: String
    let passwordConfirm: String
}

struct User {
    let login: String
    let favoriteFilms: [String]
}
