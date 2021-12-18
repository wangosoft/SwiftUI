//
//  AppConstants.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import SwiftUI

struct ServiceConstants {
    struct Url {
        static let fruit = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list"
        static let fruitDetail = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/%@/detail"
    }
    
    struct Config {
        static let timeout = 30.0
    }
}

struct Storage {
    static let database = "Database"
    
    struct Predicate {
        static let equalId = "id = %@"
    }
}

struct Padding {
    static let betweenItems: CGFloat = 5.0
    static let edge: CGFloat = 10.0
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 1.0
}

struct Images {
    
}

struct Colors {
    static let light = Color(.lightGray)
    static let gray = Color.init(red: 230/255, green: 230/255, blue: 230/255)
}

enum DatabaseEntityTypes: String {
    case fruits = "Fruits"
}
