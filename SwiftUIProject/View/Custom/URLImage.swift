//
//  DynamicImageView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import SwiftUI

final class ObservableURLImage : ObservableObject {
    @Published var image: Image?
    @Published var isLoading: Bool = false

    let url: String
            
    init(url: String) {
        self.url = url
    }
    
    func load() {
        self.isLoading = true
        Service.shared.loadImage(urlString: url) { urlImage in
            DispatchQueue.main.async {
                self.isLoading = false
                if let img = urlImage {
                    self.image = Image.init(uiImage: img)
                }
            }
        }
    }
}


struct URLImage: View {
    @ObservedObject private var observableURLImage: ObservableURLImage
                    
    init(url: String) {
        observableURLImage = ObservableURLImage(url: url)
        observableURLImage.load()
    }
    
    var body: some View {
        ZStack {
            CustomProgressView.init(isLoading: observableURLImage.isLoading, addBackground: false)
            observableURLImage.image?.resizable().aspectRatio(contentMode: .fit)
        }
    }
    
}

