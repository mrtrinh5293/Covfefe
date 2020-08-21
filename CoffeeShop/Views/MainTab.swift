//
//  MainView.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/21/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @ObservedObject var drinkListener = DrinkListener()
    
    var categories: [String : [Drink]] {
        .init(
            grouping: drinkListener.drinks, by: {$0.category.rawValue}
        )
    }
    
    var body: some View {
            
            List(categories.keys.sorted(), id: \String.self) { key in
                DrinkRow(categoryName: "\(key) Drinks".uppercased(), drinks: self.categories[key]!)
                    .frame(height: 320)
                    .padding(.top)
                    .padding(.bottom)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
