//
//  FruitModel.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import Foundation

struct FruitModel: Decodable, Identifiable {
    var id: String
    var name: String
    var price: Int
    var image: String?
    var description: String?
    var imageData: Data?
    
    private enum CodingKeys : String, CodingKey {
        case id = "product_id", name, price, image, description, imageData
    }
}

struct FruitsModelResponse: Decodable {
    var products: [FruitModel]
}
