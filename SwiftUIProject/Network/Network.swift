//
//  Services.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    func request<T: Decodable>(httpMethod: HttpMethodType, urlString: String, completion: @escaping (Result<T?, NetworkError>) -> Void)
}
    
final class Network: NetworkProtocol {
    static let shared: Network = Network()
        
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("badUrl")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = ServiceConstants.Config.timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }

    func request<T: Decodable>(httpMethod: HttpMethodType, urlString: String, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = ServiceConstants.Config.timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.unknown))
            }
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.parse))
                return
            }
            completion(.success(response))
        }.resume()
    }
    
}

enum NetworkError: Error {
    case badUrl
    case noData
    case parse
    case unknown
}

enum HttpMethodType: String {
    case get = "Get"
    case post = "Post"
    case put = "Put"
    case delete = "Delete"
}
