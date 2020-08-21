//
//  ContentView.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/13/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var drinkListener = DrinkListener()
    @State private var showingBasket = false
    @State private var isLogged = false
    @ObservedObject var userSettings = UserSettings()

    var categories: [String : [Drink]] {
        .init(
            grouping: drinkListener.drinks, by: {$0.category.rawValue}
        )
    }
    
    var body: some View {
        
        VStack {
            NavigationView {
                TabView {
                    MainTab().tabItem{
                        Tab(imageName: "list.dash", text: "Menu")
                            .tag(0)
                    }.navigationViewStyle(DoubleColumnNavigationViewStyle())
                    
                    OptionTabView().tabItem {
                        Tab(imageName: "person", text: "Option")
                            .tag(1)
                    }.navigationViewStyle(DoubleColumnNavigationViewStyle())
                }
                .navigationBarTitle(Text("Covfefe"))
                            .navigationBarItems(leading:
                    
                    Button(action: {

                        FUser.logOutCurrentUser { (error) in
                            print("error loging out user, ", error?.localizedDescription)
                        }
                    }, label: {
                        Text(FUser.currentUser() != nil && FUser.currentUser()!.onBoarding ? "Log Out" :"")
                    })
                    
                    , trailing:
                
                    Button(action: {
                        self.showingBasket.toggle()
                    }, label: {
                        Image("basket")
                    })
                        .sheet(isPresented: $showingBasket) {

                            if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
                                
                                OrderBasketView()
                            } else if FUser.currentUser() != nil {
                                FinishRegistrationView()
                            } else {
                                LoginView()
                            }
                    }
                
                )
            } // navigation
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

private struct Tab: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}
