//
//  FirebaseReference.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/13/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Menu
    case Order
    case Basket
    
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
