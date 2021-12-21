//
//  DetailView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import SwiftUI

struct DetailView: View {
    
    var fruit: FruitModel?
    @ObservedObject private var detailViewModel: DetailViewModel

    init(fruit: FruitModel?) {
        detailViewModel = DetailViewModel()
        if let productId = fruit?.id {
            detailViewModel.getFruitDetail(productId: productId)
        }
    }
        
    var body: some View {
        VStack {
            CustomProgressView(isShowing: $detailViewModel.isShowing, addBackground: true)
            if let fruit = detailViewModel.fruitDetail {
                if let image = fruit.image {
                    URLImage(url: image)
                } else {
                    URLImage(image: UIImage(data: fruit.imageData ?? Data()))
                }
                Text(fruit.name).bold().padding(Padding.betweenItems)
                Text("\(fruit.price)").foregroundColor(Colors.light).bold().padding(Padding.betweenItems)
                Text("\(fruit.description ?? "")").foregroundColor(Colors.light).padding().multilineTextAlignment(.center)
            }
            if detailViewModel.isShowError {
                ErrorView.init(errorDescription: $detailViewModel.errorDescription) {
                    if let productId = fruit?.id {
                        detailViewModel.getFruitDetail(productId: productId)
                    }
                }
            } else {
                Spacer()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(fruit: nil)
    }
}
