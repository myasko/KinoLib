//
//  DataManager.swift
//  DetailsKinoLib
//
//  Created by Георгий Бутров on 01.11.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    
    private init() {}
    
    func setFavoriteStatus(for filmName: String, with status: Bool) {
        userDefaults.set(status, forKey: filmName)
    }
    
    func getFavoriteStatus(for filmName: String) -> Bool {
        userDefaults.bool(forKey: filmName)
    }
}
