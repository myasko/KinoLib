//
//  User.swift
//  KinoLib
//
//  Created by Максим on 18.11.2021.
//

import Foundation

struct User {
    let identifier = UUID().uuidString
    let firstName: String
    let lastName: String
    let login: String
    let imageUrl: URL?
}
