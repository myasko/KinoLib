//
//  AuthPresenter.swift
//  KinoLib
//
//  Created by KoroLion on 16.11.2021.
//

import Foundation
import Firebase

class SignupPresenter {
    func signup(_ user: UserSignup, callback: @escaping (String) -> ()) {
        if (user.email.count == 0) {
            callback("Email не может быть пустым")
            return
        }
        
        if (user.password.count == 0) {
            callback("Пароль не может быть пустым")
            return
        }
        
        if (user.password != user.passwordConfirm) {
            callback("Пароль и подтверждение не совпадают")
            return
        }
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) {
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
            case .emailAlreadyInUse:
                err = "EMail уже зарегистрирован"
            case .weakPassword:
                err = "Слабый пароль"
            default:
                err = "Произошла неизвестная ошибка"
            }
            
            callback(err)
        }
    }
}
