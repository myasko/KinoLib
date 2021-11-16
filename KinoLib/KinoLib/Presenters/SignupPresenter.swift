//
//  AuthPresenter.swift
//  KinoLib
//
//  Created by KoroLion on 16.11.2021.
//

import Foundation

class SignupPresenter {
    func signup(_ user: UserSignup) -> String {
        if (user.username.count == 0) {
            return "Логин не может быть пустым"
        }
        
        if (user.password.count == 0) {
            return "Пароль не может быть пустым"
        }
        
        if (user.password != user.passwordConfirm) {
            return "Пароль и подтверждение не совпадают"
        }
        
        return ""
    }
}
