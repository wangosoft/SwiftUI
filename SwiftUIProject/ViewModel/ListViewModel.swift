//
//  ListViewModel.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation

class ListViewModel: BaseViewModel {
    @Published var fruits: [FruitModel] = []

    func getFruits() {
        isShowing = true
        isShowError = false
        Service.shared.getFruits { response, error in
            DispatchQueue.main.async { self.isShowing = false }
            if let fruits = response?.products {
                DatabaseUtility.getSharedInstance().storeObjects(entity: .fruits, objects: fruits)
                DispatchQueue.main.async {
                    self.fruits = fruits
                }
            } else if let error = error {
                if let fruits: [FruitModel] = DatabaseUtility.getSharedInstance().fetchObjects(entity: .fruits) {
                    DispatchQueue.main.async {
                        self.fruits = fruits
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isShowError = true
                        self.errorDescription = error.localizedDescription
                    }
                }
            }
        }
    }
}

