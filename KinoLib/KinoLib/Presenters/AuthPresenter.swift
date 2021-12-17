//
//  AuthPresenter.swift
//  KinoLib
//
//  Created by KoroLion on 16.11.2021.
//

import Foundation
import Firebase

class AuthPresenter {
    func authenticate(_ user: UserAuth, callback: @escaping (String) -> ()) {
        if (user.email.count == 0) {
            callback("Email не может быть пустым")
            return
        }
        
        if (user.password.count == 0) {
            callback("Пароль не может быть пустым")
            return
        }
        
        Auth.auth().signIn(withEmail: user.email, password: user.password) {
            authResult, error in
            
            if (error == nil) {
                callback("")
                return
            }
            
            let errCode = AuthErrorCode(rawValue: error!._code)
            var err: String
            
            switch errCode {
            case .invalidEmail:
                err = "Некорректный EMail"
            case .userNotFound:
                err = "Неверный email или пароль"
            case .wrongPassword:
                err = "Неверный email или пароль"
            default:
                err = "Произошла неизвестная ошибка"
            }
            
            callback(err)
        }
    }
}
