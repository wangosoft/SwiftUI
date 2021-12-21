//
//  ListView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import SwiftUI

struct ListView: View {
    var fruit: FruitModel

    var body: some View {
        VStack {
            if let image = fruit.image {
                URLImage(url: image) { data in
                    DatabaseUtility.getSharedInstance().update(entity: .fruits, theObject: fruit, with: data, key: Storage.UpdateKeys.imageData)
                }.frame(maxWidth: .infinity, idealHeight: 450, maxHeight: 450, alignment: .center)
                .padding(Padding.betweenItems)
            } else {
                URLImage(image: UIImage(data: fruit.imageData ?? Data()))
                    .frame(maxWidth: .infinity, idealHeight: 150, maxHeight: 150, alignment: .center)
                    .padding(Padding.betweenItems)
            }
            Text(fruit.name).bold().padding(Padding.betweenItems)
            Text("\(fruit.price)").foregroundColor(Colors.light).bold()
        }.frame(minWidth: 0, maxWidth: (UIScreen.main.bounds.size.width - Padding.edge * 3) / 2, maxHeight: 200)
        .padding()
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: Padding.cornerRadius)
                    .stroke(Colors.light, lineWidth: Padding.borderWidth)
                    .shadow(color: Colors.light, radius: Padding.cornerRadius, x: 0.0, y: 1.0).opacity(0.5))
    }
}

