//
//  Service.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import UIKit

protocol ServiceProtocol {
    func getFruits(completion: @escaping (_ response: FruitsModelResponse?, _ error: NetworkError?) -> Void)
    func getFruitDetail(productId: String, completion: @escaping (_ response: FruitModel?, _ error: NetworkError?) -> Void)
}

final class Service: ServiceProtocol {
    static let shared: Service = Service()
    
    func getFruits(completion: @escaping (_ response: FruitsModelResponse?, _ error: NetworkError?) -> Void) {
        Network.shared.request(httpMethod: .get, urlString: ServiceConstants.Url.fruit) { (result: Result<FruitsModelResponse?, NetworkError>) in
            switch result {
            case .success(let fruitsModelResponse):
                completion(fruitsModelResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getFruitDetail(productId: String, completion: @escaping (FruitModel?, NetworkError?) -> Void) {
        Network.shared.request(httpMethod: .get, urlString: String(format: ServiceConstants.Url.fruitDetail, productId)) { (result: Result<FruitModel?, NetworkError>) in
            switch result {
            case .success(let fruitModel):
                completion(fruitModel, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        Network.shared.loadImage(urlString: urlString) { image in
            completion(image)
        }
    }
    
}

