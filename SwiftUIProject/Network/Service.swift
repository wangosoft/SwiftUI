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
}

class Service: ServiceProtocol {
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
}

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage()
        
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
