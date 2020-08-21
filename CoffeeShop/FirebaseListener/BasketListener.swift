
//
//  BasketListener.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/17/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation
import Firebase

class BasketListener: ObservableObject {
    @Published var orderBasket: OrderBasket!
    
    init() {
        downloadBasket()
    }
    
    func downloadBasket() {
        
        //access Firebase reference
        
        // check if any user logged in
        
        if FUser.currentUser() != nil {
            
            FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: FUser.currentId()).addSnapshotListener { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if !snapshot.isEmpty {
                    
                    let basketData = snapshot.documents.first!.data()
                    
                    // get drinks from the basket
                    getDrinksFromFirestore(withIds: basketData[kDRINKIDS] as? [String] ?? []) { (allDrinks) in
                        
                        //create order basket object
                        let basket = OrderBasket()
                        basket.ownerId = basketData[kOWNERID] as? String
                        basket.id = basketData[kID] as? String
                        basket.items = allDrinks
                        self.orderBasket = basket
                    }
                }
            }
        }
    }
}

// call back function, -> Void not return anything
func getDrinksFromFirestore(withIds: [String], completion: @escaping(_ drinkArray: [Drink]) -> Void) {
    
    var count = 0
    var drinkArray: [Drink] = []
    
    if withIds.count == 0 {
        completion(drinkArray)
        return
    }
    
    for drinkId in withIds {
 
        FirebaseReference(.Menu).whereField(kID, isEqualTo: drinkId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                
                let drinkData = snapshot.documents.first!
                
                drinkArray.append(Drink(id: drinkData[kID] as? String ?? UUID().uuidString,
                                        name: drinkData[kNAME] as? String ?? "unknown",
                                        imageName: drinkData[kIMAGENAME] as? String ?? "Unknown",
                                        category: Category(rawValue: drinkData[kCATEGORY] as? String ?? "cold") ?? .cold,
                                        description: drinkData[kDESCRIPTION] as? String ?? "no des",
                                        price: drinkData[kPRICE] as? Double ?? 0.00 ))
                count += 1
            } else {
                
                print("have no drink \(error)")
                completion(drinkArray)
            }
            
            //track how many item we have downloaded
            if count == withIds.count {
                completion(drinkArray)
            }
        }
        
    }
}
