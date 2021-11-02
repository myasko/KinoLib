//
//  NetworkManager.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func getFilms<T:Codable>(ofType: T.Type, completion: @escaping (Result<T?, Error>) -> Void)
    func formRequest (url: String) -> URLRequest?
}

final class NetworkManager: NetworkManagerProtocol {
    var url: String = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top?type=TOP_250_BEST_FILMS&page=1"
    private let token = "17aeb90d-e138-4564-842c-732e80e90401"
    func getFilms<T:Codable>(ofType: T.Type, completion: @escaping (Result<T?, Error>) -> Void){
        guard let request = formRequest(url: url) else {return}
        URLSession.shared.dataTask(with: request) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
//                print(String(data: data!, encoding: .utf8))
                let obj = try JSONDecoder().decode(ofType, from: data!)
                completion(.success(obj))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func formRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        return request
    }
}
