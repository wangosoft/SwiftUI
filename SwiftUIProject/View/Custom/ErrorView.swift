//
//  ErrorView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 19.12.2021.
//

import SwiftUI

struct ErrorView: View {
    @Binding var errorDescription: String
    let action : () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text(Localize.Error.title).font(.body.bold()).multilineTextAlignment(.center).foregroundColor(Colors.black).padding()
                Text(errorDescription).font(.body).multilineTextAlignment(.center).foregroundColor(Colors.darkGray).padding()
                Button(action: {
                    action()
                }, label: {
                    Text(Localize.Error.tryAgain).bold()
                }).padding().background(Colors.light).foregroundColor(Colors.black).cornerRadius(Padding.cornerRadius)
            }
        }
    }
}
