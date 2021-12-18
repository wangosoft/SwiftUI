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
                DatabaseUtility.shared.deleteAllObjects(entity: .fruits)
                DatabaseUtility.shared.storeObjects(entity: .fruits, fruits: fruits)
                DispatchQueue.main.async {
                    self.fruits = fruits
                }
            } else if let _ = error {
                DispatchQueue.main.async {
                    self.fruits = DatabaseUtility.shared.fetchObjects(entity: .fruits)
                }
            }
        }
    }
    func getFruitDetail(productId: String) {
        Service.shared.getFruitDetail(productId: productId) { response, error in
            if let fruit = response {
                DatabaseUtility.shared.update(entity: .fruits, withObject: fruit)
                DispatchQueue.main.async {
                    self.fruitDetail = fruit
                }
            } else if let _ = error {
                DispatchQueue.main.async {
                    self.fruitDetail = DatabaseUtility.shared.fetchObjectsWithId(entity: .fruits, id: productId) 
                }
            }
        }
    }
    
}
