//
//  LoginView.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/17/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State var showingSignup = false
    @State var showingFinishReg = false
    @State var alert = false
    @State var visible = false
    @State var forgotPass = false
    
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSettings = UserSettings()
    
    @State var email = ""
    @State var password = ""
    @State var repeatPassword = ""
    
    
    @State var title = ""
    @State var message = ""
    
    @State var color = Color.black.opacity(0.7)
    var body: some View {
        
        VStack {
            
            
            VStack {
                Image("covfefe-1").resizable().aspectRatio(contentMode: .fit)
                
                if forgotPass {
                    
                    Text("Forgot your Password")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        TextField("Enter your email", text: $email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("yelow") : self.color,lineWidth: 2))
                    }
                    
                    Button(action: {
                        
                        self.resetPassword()
                    }, label: {
                        Text("Send Email Verification")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 120)
                            .padding()
                    }) //End of Button
                        .background(Color("yelow"))
                        .cornerRadius(10)
                        .padding(.top, 45)
                    
                    Button(action: {
                        self.forgotPass.toggle()
                        
                    }, label: {
                        Text("Back to Login")
                            
                            .fontWeight(.bold)
                            .foregroundColor(Color("yelow"))
                    }).padding(.top, 25)
                    
                    Spacer()
                } else {
                    
                    Text("Log in to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        
                        TextField("Enter your email", text: $email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("yelow") : self.color,lineWidth: 2))
                        
                        HStack {
                            
                            VStack {
                                if self.visible{
                                    TextField("Enter your password", text: $password)
                                        .autocapitalization(.none)
                                } else {
                                    
                                    SecureField("Enter your password", text: $password)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("yelow") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        if showingSignup {
                            
                            HStack {
                                VStack {
                                    if self.visible{
                                        TextField("Repeat your password", text: $repeatPassword)
                                            .autocapitalization(.none)
                                    } else {
                                        
                                        SecureField("Repeat your password", text: $repeatPassword)
                                            .autocapitalization(.none)
                                    }
                                }
                                Button(action: {
                                    self.visible.toggle()
                                }) {
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.color)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("yelow") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                        }
                        
                        
                    }
                    .padding(.bottom, 15)
                    .animation(.easeOut(duration: 0.1))
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            self.forgotPass.toggle()
                            
                        }, label: {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                                .foregroundColor(Color("yelow"))
                        })
                    }//End of HStack
                    
                    Button(action: {
                        
                        self.showingSignup ? self.signUpUser() : self.loginUser()
                    }, label: {
                        Text(showingSignup ? "Sign Up" : "Sign In")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 120)
                            .padding()
                    }) //End of Button
                        .background(Color("yelow"))
                        .cornerRadius(10)
                        .padding(.top, 45)
                    //End of VStack
                    SignUpView(showingSignup: $showingSignup)
                    
                }
            } .padding(.horizontal, 6)
        }//End of VStack
            //added
            .alert(isPresented: $alert) {
                Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")
                    ))
        }
            //
            .animation(.spring())
            .sheet(isPresented: $showingFinishReg) {
                FinishRegistrationView()
        }
        
    }//End of body
    
//    private func loginUser() {
//
//        if email != "" && password != "" {
//
//            FUser.loginUserWith(email: email, password: password) { (error, isEmailVerified) in
//
//                if error != nil {
//
//                    print("error loging in the user: ", error!.localizedDescription)
//                    return
//                }
//
//                if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
//                    self.presentationMode.wrappedValue.dismiss()
//                } else {
//                    self.showingFinishReg.toggle()
//                }
//
//            }
//        }
//
//    }
    
    private func loginUser() {
        
        if email != "" && password != "" {
            FUser.loginUserWith(email: email, password: password) { (error, isEmailVerified) in
                
                if error != nil {
                    print("error loging in the user: ", error!.localizedDescription)
                    return
//                        self.userSettings.isLoggedIn.toggle()
                }
            }
            if FUser.currentUser() != nil && FUser.currentUser()!.onBoarding {
                self.presentationMode.wrappedValue.dismiss()
            } else if FUser.currentUser() != nil {
                self.showingFinishReg.toggle()
            }
            else {
                self.title = "ERROR!"
                self.message = "Please check your email and password"
                self.alert.toggle()
            }
        }
        else {
            self.title = "ERROR!"
            self.message = "Please fill up the requirement field(s)"
            self.alert.toggle()
        }
        
    }
    
    private func signUpUser() {
        
        if email != "" && password != "" && repeatPassword != "" {
            if password == repeatPassword {
                FUser.registerUserWith(email: email, password: password) { (error) in
                    
                    if error != nil {
                        print("Error registering user: ", error!.localizedDescription)
                        self.alert.toggle()
                        return
                    }
                    
                    self.title = "Success!"
                    self.message = "Please verify your email."
                    self.alert.toggle()
                    
                }
            } else {
                self.title = "Error!"
                self.message = "passwords don't match."
                self.alert.toggle()
            }
            
            
        } else {
            self.title = "Error!"
            self.message = "Email and password must be set."
            self.alert.toggle()
        }
        
    }
    private func resetPassword() {
        if email != "" {
            FUser.resetPassword(email: email) { (error) in
                if error != nil {
                    print("error sending reset password, ", error!.localizedDescription)
                    self.title = "Error!"
                    self.message = "There is no user record corresponding to this identifier"
                    self.alert.toggle()
                    return
                }
                
                self.title = "Note!"
                self.message = "Please check your email and password"
                self.alert.toggle()
            }
            
        } else {
            //notify the user
            self.title = "Error!"
            self.message = "Please enter your email"
            self.alert.toggle()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct SignUpView : View {
    
    @Binding var showingSignup: Bool
    var body: some View {
        
        VStack {
            Spacer()
            
            if showingSignup == false {
                
                HStack(spacing: 8) {
                    Text("Don't have an account? ")
                        .foregroundColor(Color.gray.opacity(1))
                    
                    Button(action: {
                        self.showingSignup.toggle()
                    }, label: {
                        Text("Sign Up")
                    })
                        .foregroundColor(Color("yelow"))
                }
            } else {
                Button(action: {
                    self.showingSignup.toggle()
                }, label: {
                    Text("Sign In")
                })
                    .foregroundColor(Color("yelow"))
            }
        }
    }
}
