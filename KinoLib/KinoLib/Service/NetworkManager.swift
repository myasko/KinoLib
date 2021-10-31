//
//  NetworkManager.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func getFilms (completion: @escaping (Result<[Film]?, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    var request: String = ""
    
    func getFilms (completion: @escaping (Result<[Film]?, Error>) -> Void){
        guard let url = URL(string: request) else {
            return
        }
        URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode([Film].self, from: data!)
                completion(.success(obj))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
