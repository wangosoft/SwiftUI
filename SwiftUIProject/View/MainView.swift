//
//  ContentView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var listViewModel: ListViewModel
    
    init() {
        listViewModel = ListViewModel()
    }
        
    var body: some View {
        NavigationView {
            let columns: [GridItem] = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            ScrollView {
                LazyVGrid.init(columns: columns, spacing: Padding.edge) {
                    ForEach(listViewModel.fruits) { fruit in
                        ListView(name: fruit.name, price: fruit.price, imageUrl: fruit.image).frame(minWidth: 0, maxWidth: .infinity)
                    }
                }.padding(Padding.edge)
            }
            .navigationBarTitle(Text("Fruits"))
        }.onAppear() {
            self.listViewModel.getFruits()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}
