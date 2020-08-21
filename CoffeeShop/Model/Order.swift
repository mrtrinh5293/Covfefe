//
//  Order.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/17/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation

class Order: Identifiable {
    
    var id: String!
    var customerId: String!
    var orderItems: [Drink] = []
    var amount: Double!
    var customerName: String!
    var isCompleted: Bool!
    
    func saveOrderToFirestore() {
        
        FirebaseReference(.Order).document(self.id).setData(orderDictionaryFrom(self)) { // self : class object itself
            error in
            if error != nil {
                print("Error saving order to firestore \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func orderDictionaryFrom(_ order: Order) -> [String : Any] {
        
        var allDrinksIds: [String] = []
        
        for drink in order.orderItems {
            allDrinksIds.append(drink.id)
        }
        
        return NSDictionary(objects: [ order.id,
                                       order.customerId,
                                       allDrinksIds,
                                       order.amount,
                                       order.customerName,
                                       order.isCompleted
            ],
                            forKeys: [ kID as NSCopying,
                                       kCUSTOMERID as NSCopying,
                                       kDRINKIDS as NSCopying,
                                       kAMOUNT as NSCopying,
                                kCUSTOMERNAME as NSCopying,
                                kISCOMPLETED as NSCopying
        ]) as! [String : Any]
    }
}
