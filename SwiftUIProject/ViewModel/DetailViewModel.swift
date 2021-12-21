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
                DatabaseUtility.getSharedInstance().update(entity: .fruits, theObject: fruit, with: fruit.description, key: Storage.UpdateKeys.fruit_description)
                DispatchQueue.main.async {
                    self.fruitDetail = fruit
                }
            } else if let fruitDetail: FruitModel? = DatabaseUtility.getSharedInstance().fetchObjectsWithId(entity: .fruits, id: productId) {
                DispatchQueue.main.async {
                    self.fruitDetail = fruitDetail
                }
            } else {
                DispatchQueue.main.async {
                    self.isShowError = true
                    self.errorDescription = error?.localizedDescription ?? Localize.General.empty
                }
            }
        }
    }
}
