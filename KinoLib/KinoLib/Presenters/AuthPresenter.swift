//
//  AuthPresenter.swift
//  KinoLib
//
//  Created by KoroLion on 16.11.2021.
//

import Foundation

class AuthPresenter {
    func authenticate(_ user: UserAuth) -> String {
        if (user.username.lowercased() == "wolf" && user.password == "1234") {
            return ""
        }
        
        return "Неверный логин или пароль!"
    }
}
