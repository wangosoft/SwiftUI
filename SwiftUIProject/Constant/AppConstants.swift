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
    
    struct UpdateKeys {
        static let imageData = "imageData"
        static let fruit_description = "fruit_description"
    }
}

struct Padding {
    static let betweenItems: CGFloat = 5.0
    static let edge: CGFloat = 10.0
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 1.0
}

struct Images {
    static let noImage = UIImage.init(named: "no_image")
}

struct Colors {
    static let light = Color(.lightGray)
    static let darkGray = Color(.darkGray)
    static let black = Color(.black)
    static let gray = Color.init(red: 230/255, green: 230/255, blue: 230/255)
}

struct XCUnitTest {
    struct Expectation {
        static let waitAsyncListApiRequest = "waitAsyncListApiRequest"
        static let waitAsyncDetailApiRequest = "waitAsyncDetailApiRequest"
        static let waitAsyncLoadImageApiRequest = "waitAsyncLoadImageApiRequest"
    }
    struct MockData {
        static let fruit_description = "fruit_description"
        static let productId = "1"
        static let imageUrl = "https://s3-eu-west-1.amazonaws.com/developer-application-test/images/1.jpg"
        static let fruit = [FruitModel(id: "100", name: "test", price: 100, image: "testImageUrl", description: "decription")]
        static let updateWithFruit = [FruitModel(id: "101", name: "test1", price: 101, image: "testImageUrl1", description: "decription1")]
    }
}

enum DatabaseEntityTypes: String {
    case fruits = "Fruits"
}
