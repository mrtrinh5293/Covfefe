//
//  DrinkRow.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/14/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct DrinkRow: View {
    
    var categoryName: String
    var drinks : [Drink]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.categoryName)
                .font(.title)
            ScrollView(.horizontal, showsIndicators: false ) {
                HStack {
                    ForEach(self.drinks) { drink in
                        
                        NavigationLink(destination: DrinkDetail(drink: drink)) {
                            DrinkItem(drink: drink)
                                .frame(width: 300)
                                .padding(.trailing, 30)
                        }
                    }
                }
            }
            
        }
    }
}

struct DrinkRow_Previews: PreviewProvider {
    static var previews: some View {
        DrinkRow(categoryName: "Cool", drinks: drinkData)
    }
}
