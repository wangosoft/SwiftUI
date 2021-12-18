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
            ZStack {
                ScrollView {
                    LazyVGrid.init(columns: columns, spacing: Padding.edge) {
                        ForEach(listViewModel.fruits) { fruit in
                            NavigationLink(destination: DetailView(fruit: fruit)) {
                                ListView(fruit: fruit).frame(minWidth: 0, maxWidth: (UIScreen.main.bounds.size.width - Padding.edge * 3) / 2, maxHeight: 200)
                            }
                        }
                    }.padding(Padding.edge)
                }
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
