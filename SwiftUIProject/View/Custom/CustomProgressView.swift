//
//  CustomProgressView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 18.12.2021.
//

import SwiftUI
    
struct CustomProgressView: View {
    @Binding var isShowing: Bool
    var addBackground = true
    
    var body: some View {
        ProgressView()
            .padding()
            .background(addBackground ? Colors.gray : .clear)
            .cornerRadius(Padding.cornerRadius)
            .shadow(radius: Padding.cornerRadius)
            .opacity(isShowing ? 1 : 0)
    }
}

