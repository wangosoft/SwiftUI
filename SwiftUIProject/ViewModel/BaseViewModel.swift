//
//  BaseViewModel.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var isShowError: Bool = false
    @Published var errorDescription: String = Localize.General.empty
}
