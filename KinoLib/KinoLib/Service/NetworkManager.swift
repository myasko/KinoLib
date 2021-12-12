//
//  NetworkManager.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 29.10.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func get<T:Codable>(ofType: T.Type, url: String, completion: @escaping (Result<T?, Error>) -> Void)
    func formRequest (url: String) -> URLRequest?
}

final class NetworkManager: NetworkManagerProtocol {
    private var url: String!
    private let token = "3eb9f76abfcf6dfa4ac87f43b1f2bdb9"
    func get<T:Codable>(ofType: T.Type, url: String, completion: @escaping (Result<T?, Error>) -> Void){
        guard let request = formRequest(url: url) else {return}
        URLSession.shared.dataTask(with: request) {data, response, error in
//            if let response = response as? HTTPURLResponse{
//                print ("[Debug] \(response.statusCode)")
//            }
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
//                print(String(data: data!, encoding: .utf8))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let obj = try decoder.decode(ofType, from: data!)
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
//        request.cachePolicy = .returnCacheDataDontLoad
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = "GET"
        return request
    }
}
