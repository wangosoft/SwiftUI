//
//  ListView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import SwiftUI

struct ListView: View {
    var name: String
    var price: Int
    var imageUrl: String
    
    var body: some View {
        ZStack {
            VStack {
                DynamicImageView(urlString: imageUrl).frame(minWidth: 0, maxWidth: .infinity)
                Text(name).bold().padding(Padding.betweenItems)
                Text("\(price)").foregroundColor(Colors.light).bold()
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: Padding.cornerRadius)
            .stroke(Colors.light, lineWidth: Padding.borderWidth)
            .shadow(color: Colors.light, radius: Padding.cornerRadius, x: 0.0, y: 1.0).opacity(0.5))
        }
        
    }
}

