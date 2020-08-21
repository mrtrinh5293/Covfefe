//
//  DrinkDetail.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/15/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct DrinkDetail: View {
    
    var drink: Drink
    
    @State private var showingAlert = false
    @State private var showingLogin = false
    @State private var hearty = false
    
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            
            VStack {
                
                Image(drink.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .clipShape(CustomShape(corner: .bottomLeft, radii: 55))
                
                
            }
            
            ScrollView(self.height > 800 ? .init() : .vertical, showsIndicators: false) {
                VStack {
                    HStack{
                        
                        Text(drink.name)
                            .fontWeight(.bold)
                            .font(.title)
                        .foregroundColor(Color("Color"))
                        
                        Spacer()
                        
                        Button(action: {
                            self.hearty.toggle()
                        }) {
                            
                            Image("heart")
                                .renderingMode(.original)
                                .padding()
                            
                        }
                        .background(self.hearty ? Color.red : Color("yelow"))
                        .clipShape(Circle())
                    } // name and heart
                        .padding(.horizontal, 35)
                        .padding(.top, 35)
                    
                    Text(drink.description)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 30)
                        .padding(.top,20)
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 30){
                        
                        Button(action: {
                            
                        }) {
                            
                            VStack{
                                
                                Image(systemName: "leaf.arrow.circlepath")
                                    .renderingMode(.original)
                                
                                Text("Cool")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background(Color("yelow"))
                        .cornerRadius(12)
                        
                        Button(action: {
                            
                        }) {
                            
                            VStack{
                                
                                Image(systemName: "staroflife")
                                    .renderingMode(.original)
                                
                                Text("Cold")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background(Color("yelow"))
                        .cornerRadius(12)
                        
                        Button(action: {
                            
                        }) {
                            
                            VStack{
                                
                                Image(systemName: "flame")
                                    .renderingMode(.original)
                                
                                Text("Hot")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background(Color("yelow"))
                        .cornerRadius(12)
                        
                        Button(action: {
                            
                        }) {
                            
                            VStack{
                                
                                Image(systemName: "paperplane")
                                    .renderingMode(.original)
                                
                                Text("Plane")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                        .background(Color("yelow"))
                        .cornerRadius(12)
                    } // 4 options
                        .padding(.top, 20)
                        .padding(.bottom, 25)
                    Spacer(minLength: 0)
                }
            }.background(CustomShapee().fill(Color.white))
//                .padding(.bottom, 20)
            .clipShape(Corners())
                .offset(y: -30)
            
            
            
            Spacer(minLength: 0)
            
            HStack{
                
                Text("$\(drink.price.clean)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 35)
                    .padding(.bottom,25)
                
                Spacer()
                
                OrderButton(showAlert: $showingAlert, showLogin: $showingLogin, drink: drink)
                
            }.background(Color("Color"))
//                .padding(.bottom, 80)
            
        } // VStack
                    .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        .background(Color("Color"))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Added to Basket!"), dismissButton: .default(Text("Oke")))
        }
        
        
        
    }
    
}

struct DrinkDetail_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDetail(drink: drinkData.first!)
    }
}

struct OrderButton : View {
    
    @ObservedObject var basketListener = BasketListener()
    @Binding var showAlert : Bool
    @Binding var showLogin : Bool
    
    
    
    var drink: Drink
    
    var body: some View {
        Button(action: {
            if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
                
                self.showAlert.toggle()
                self.addItemToBasket()
                
            } else  {
                self.showLogin.toggle()
            }
            
        }) {
            Text("Add To Basket").foregroundColor(.white).fontWeight(.bold)
        }
        .foregroundColor(.black)
                               .padding(.vertical, 20)
                               .padding(.horizontal, 35)
            .background(Color("yelow"))
            .clipShape(CustomShape(corner: .topLeft, radii: 55))
        .sheet(isPresented: self.$showLogin) {
            
            if FUser.currentUser() != nil {
                FinishRegistrationView()
            } else {
                LoginView()
            }
        }
        
    }
    
    private func addItemToBasket() {
        var orderBasket: OrderBasket!
        
        if self.basketListener.orderBasket != nil {
            
            orderBasket = self.basketListener.orderBasket
        } else {
            
            orderBasket = OrderBasket()
            orderBasket.ownerId = FUser.currentId()
            orderBasket.id = UUID().uuidString
        }
        // check if user has basket
        orderBasket.add(self.drink)
        orderBasket.saveBasketToFireStore()
    }
}
