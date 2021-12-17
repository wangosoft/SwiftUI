//
//  DynamicImageView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import SwiftUI
    
//struct DynamicImageView: View {
//    var urlString: String
//    @ObservedObject var imageLoader = ImageLoaderService()
//    @State var image: UIImage = UIImage()
//
//    var body: some View {
//        Image(uiImage: image)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .onReceive(imageLoader.$image) { image in
//                self.image = image
//            }
//            .onAppear {
//                imageLoader.loadImage(for: urlString)
//            }
//    }
//}


final class ObservableURLImage : ObservableObject {
    @Published var image: Image?
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func load() {
        Service.shared.loadImage(urlString: url) { urlImage in
            if let img = urlImage {
                DispatchQueue.main.async {
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
        observableURLImage.image?.resizable().aspectRatio(contentMode: .fit)
    }
    
}

