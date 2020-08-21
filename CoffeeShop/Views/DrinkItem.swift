//
//  DrinkItem.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/14/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct DrinkItem: View {
    
    var drink: Drink
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(drink.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            VStack(alignment: .leading, spacing: 5) {
                Text(drink.name)
                    .foregroundColor(.primary)
                    .font(.headline)
                
                Text(drink.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                .lineLimit(2)
            }
        }
    }
}

struct DrinkItem_Previews: PreviewProvider {
    static var previews: some View {
        DrinkItem(drink: drinkData[0])
    }
}
