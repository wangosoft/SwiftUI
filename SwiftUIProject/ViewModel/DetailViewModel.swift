//
//  DetailViewModel.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 18.12.2021.
//

import Foundation

class DetailViewModel: BaseViewModel {
    @Published var fruitDetail: FruitModel?

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
