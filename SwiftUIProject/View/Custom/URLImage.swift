//
//  DynamicImageView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import SwiftUI
import UIKit

final class ObservableURLImage : ObservableObject {
    @Published var image: Image?
    @Published var isShowing: Bool = false

    let url: String

    init(url: String) {
        self.url = url
    }

    func load(completion: @escaping (Data) -> ()) {
        self.isShowing = true
        Service.shared.loadImage(urlString: url) { urlImage in
            DispatchQueue.main.async {
                self.isShowing = false
                if let img = urlImage {
                    self.image = Image(uiImage: img)
                    if let data = img.jpegData(compressionQuality: 1.0) {
                        completion(data)
                    }
                } else {
                    self.image = Image(uiImage: Images.noImage!)
                }
            }
        }
    }
}

struct URLImage: View {
    @ObservedObject private var observableURLImage: ObservableURLImage
        
    init(url: String, completion: @escaping (Data) -> () = { _ in }) {
        observableURLImage = ObservableURLImage(url: url)
        observableURLImage.load { data in
            completion(data)
        }
    }
    
    init(image: UIImage?) {
        observableURLImage = ObservableURLImage(url: Localize.General.empty)
        if let img = image {
            self.observableURLImage.image = Image(uiImage: img)
        } else {
            self.observableURLImage.image = Image(uiImage: Images.noImage!)
        }
    }
    
    var body: some View {
        ZStack {
            CustomProgressView.init(isShowing: $observableURLImage.isShowing, addBackground: false)
            observableURLImage.image?.resizable().aspectRatio(contentMode: .fit)
        }
    }
    
}

