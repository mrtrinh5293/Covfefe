//
//  UserSettings.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/19/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet{
            UserDefaults.standard.set(isLoggedIn,forKey: "isLoggedIn")
        }
    }
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
