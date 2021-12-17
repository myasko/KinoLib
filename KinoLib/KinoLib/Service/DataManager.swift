//
//  DataManager.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

class DataManager {    
    static private let userDefaults = UserDefaults.standard
    
    static func setLastEmail(_ email: String) {
        userDefaults.set(email, forKey: "lastEmail")
    }
    
    static func getLastEmail() -> String {
        return userDefaults.string(forKey: "lastEmail") ?? ""
    }
}
