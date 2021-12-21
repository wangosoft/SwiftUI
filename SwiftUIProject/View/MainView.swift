//
//  ContentView.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 16.12.2021.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private var listViewModel: ListViewModel = ListViewModel()

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
                                ListView(fruit: fruit)
                              }
                        }
                    }.padding(Padding.edge)
                }
                CustomProgressView(isShowing: $listViewModel.isShowing, addBackground: true)
                    
                if listViewModel.isShowError {
                    ErrorView.init(errorDescription: $listViewModel.errorDescription) {
                        listViewModel.getFruits()
                    }
                }
            }
            .navigationBarTitle(Text(Localize.General.fruits))
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
