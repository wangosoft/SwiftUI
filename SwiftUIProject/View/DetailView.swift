//
//  DetailView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import SwiftUI

struct DetailView: View {
    
    var fruit: FruitModel?
    @ObservedObject var listViewModel: ListViewModel

    init(fruit: FruitModel?) {
        listViewModel = ListViewModel()
        if let productId = fruit?.id {
            listViewModel.getFruitDetail(productId: productId)
        }
    }
        
    var body: some View {
        VStack {
            if let fruit = listViewModel.fruitDetail {
                URLImage(url: fruit.image)
                Text(fruit.name).bold().padding(Padding.betweenItems)
                Text("\(fruit.price)").foregroundColor(Colors.light).bold().padding(Padding.betweenItems)
                Text("\(fruit.description ?? "")").foregroundColor(Colors.light).padding().multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(fruit: nil)
    }
}
