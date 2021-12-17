//
//  ListViewModel.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation

class ListViewModel: BaseViewModel {
 
    @Published var fruits: [FruitModel] = []
    @Published var fruitDetail: FruitModel?

    func getFruits() {
        Service.shared.getFruits { response, error in
            if let fruits = response?.products {
                DispatchQueue.main.async {
                    self.fruits = fruits
                }
            }
        }
    }
    func getFruitDetail(productId: String) {
        Service.shared.getFruitDetail(productId: productId) { response, error in
            if let fruit = response {
                DispatchQueue.main.async {
                    self.fruitDetail = fruit
                }
            }
        }
    }
    
}
