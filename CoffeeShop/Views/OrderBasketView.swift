//
//  OrderBasketView.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/17/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct OrderBasketView: View {
    
    @ObservedObject var basketListener = BasketListener()
    
    static let paymentTypes = ["Cash", "Credit Card", "Visa Card"]
    static let tipAmounts = [10, 15, 20, 0]
    
    @State private var paymentType = 0
    @State private var tipAmount = 1
    @State var count = 0
    
    @State private var showingPaymentAlert = false
    
    @State var height = UIScreen.main.bounds.height
    
    var totalPrice: Double {
        
        if basketListener.orderBasket == nil {
            return 0.0
        }
        
        let total = basketListener.orderBasket.total
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    var body: some View {
        
        ZStack{
            
            Color("Color").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                
                Image("covfefee")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -90)
                    .frame(height: 300)
                
                ZStack(alignment: .topTrailing) {
                    
                    if self.height > 750 {
                        
                        VStack{
                            
                            HStack{
                                
                                Text("Order confirmation")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                                
                                Spacer()
                                
                            }.padding(.top, 25)
                            //                            NavigationView {
                            List {
                                    ForEach(self.basketListener.orderBasket?.items ?? []) {
                                        drink in
                                        
                                        HStack {
                                            Text(drink.name)
                                            Spacer()
                                            Text(" $\(drink.price.clean)")
                                        }
                                    } // foreach
                                        .onDelete { (indexSet) in
                                            self.deleteItems(at: indexSet)
                                    }
                            }.frame(height: 100)
                                Text("Payment Method")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                                    .padding(.top)
 
                                    Picker(selection: $paymentType, label: Text("")) {
                                        ForEach ( 0 ..< Self.paymentTypes.count) {
                                            Text(Self.paymentTypes[$0])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 4)

                                
                                Text("Add a Tip")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                                    .padding(.top)
                                Picker(selection: $tipAmount, label: Text("Percentage: ")){
                                    ForEach(0 ..< Self.tipAmounts.count) {
                                        Text("\(Self.tipAmounts[$0]) %")
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    // section 3
                                    .disabled(self.basketListener.orderBasket?.items.isEmpty ?? true)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal,20)
                        .background(CustomShapee().fill(Color.white))
                        .clipShape(Corners())
                    }
                }
                .zIndex(40)
                .offset(y: -85)
                .padding(.bottom, -120)
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Text("Total Price")
                            .fontWeight(.bold)
                        
                        HStack(spacing : 18){
                            
                            VStack(spacing: 8){
                                
                                Text("\(totalPrice, specifier: "%.2f")")
                                    .fontWeight(.bold)
                                
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 40)
//                    .padding(.bottom, 20)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                        
                    }) {
                        
                        VStack{
                            
                            Button(action: {
                                //show alert
                                self.showingPaymentAlert.toggle()
                                //create order
                                self.createOrder()
                                //empty basket
                                self.emptyBasket()
                            }) {
                                Text("Confirm Order").fontWeight(.bold)
                            }
                            
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
                        .background(Color("yelow"))
                        .cornerRadius(15)
                        .shadow(radius: 4)
                        .disabled(self.basketListener.orderBasket?.items.isEmpty ?? true)
                        .alert(isPresented: $showingPaymentAlert) {
                            
                            Alert(title: Text("Order comfirmed"), message: Text("Thank you!"), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.trailing, 25)
//                    .offset(y: -50)
                    
                }
                .zIndex(40)
                .padding(.bottom, 10)
                .offset(y: 40)
                
            }
            .edgesIgnoringSafeArea(.top)
            .animation(.default)
        }
        
        
        
    }
    private func createOrder() {
        
        let order = Order()
        order.amount = totalPrice
        order.id = UUID().uuidString
        order.customerId = FUser.currentId()
        order.orderItems = self.basketListener.orderBasket.items
        order.saveOrderToFirestore()
        
    }
    
    private func emptyBasket() {
        self.basketListener.orderBasket.emptyBasket()
    }
    
    func deleteItems(at offsets: IndexSet) {
        self.basketListener.orderBasket.items.remove(at: offsets.first!)
        self.basketListener.orderBasket.saveBasketToFireStore()
    }
}

struct OrderBasketView_Previews: PreviewProvider {
    static var previews: some View {
        OrderBasketView()
    }
}

