//
//  FUser.swift
//  CoffeeShop
//
//  Created by Duc Dang on 8/17/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation
import FirebaseAuth

class FUser {
    
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var phoneNumber: String
    
    var fullAddress: String?
    var onBoarding: Bool
    
    init(_id: String, _email: String, _firstName: String, _lastName: String, _phoneNumber: String) {
        id = _id
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = firstName + " " + lastName
        phoneNumber = _phoneNumber
        onBoarding = false
    }
    
    init(_ dictionary : NSDictionary) {
        
        id = dictionary[kID] as? String ?? ""
        email = dictionary[kEMAIL] as? String ?? ""
        firstName = dictionary[kFIRSTNAME] as? String ?? ""
        lastName = dictionary[kLASTNAME] as? String ?? ""
        
        fullName = firstName + " " + lastName
        fullAddress = dictionary[kFULLADDRESS] as? String ?? ""
        phoneNumber = dictionary[kPHONENUMBER] as? String ?? ""
        onBoarding = dictionary[kONBOARD] as? Bool ?? false
    }
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser.init(dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    // yser login -> call this func
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        // call auth tryna login with email n pass
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    //Download FUser object and save it locally
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email) { (error) in
                        completion(error, true)
                    }
                    
                } else {
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
        }
    }
    
    class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                authDataResult!.user.sendEmailVerification { (error) in
                    print("Verification email sent error is: ", (error?.localizedDescription ?? "err") as String)
                }
            } else {
                completion(error)
            }
        }
    }
    
    class func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            
            // also delete saved user in USerDefaults
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            
            completion(nil)
        } catch let error as Error {
            completion(error)
        }
    }
}

// func save user to Fire store

func saveUserToFirestore(fUser: FUser) {
    FirebaseReference(.User).document(fUser.id).setData(userDictionaryFrom(user: fUser)) { (error) in
        if error != nil {
            print("Error creating fuser object: ", error!.localizedDescription)
        }
    }
}

// save user locally

func downloadUserFromFirestore(userId: String, email: String, completion: @escaping (_ error: Error?) -> Void) {
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else {
            return
        }
        
        if snapshot.exists {
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
            
        } else {
            //create user
            let user = FUser(_id: userId, _email: email, _firstName: "", _lastName: "", _phoneNumber: "")
            saveUserLocally(userDictionary: userDictionaryFrom(user: user) as NSDictionary)
            saveUserToFirestore(fUser: user)
        }
        completion(error)
    }
}

func saveUserLocally(userDictionary: NSDictionary) {
    userDefaults.set(userDictionary, forKey: kCURRENTUSER)
    userDefaults.synchronize()
}

func userDictionaryFrom(user: FUser) -> [String: Any] {
    return NSDictionary(objects: [ user.id,
                                   user.email,
                                   user.firstName,
                                   user.lastName,
                                   user.fullName,
                                   user.fullAddress ?? "",
                                   user.onBoarding,
                                   user.phoneNumber
        ],
                        forKeys: [kID as NSCopying,
                                  kEMAIL as NSCopying,
                                  kFIRSTNAME as NSCopying,
                                  kLASTNAME as NSCopying,
                                  kFULLNAME as NSCopying,
                                  kFULLADDRESS as NSCopying,
                                  kONBOARD as NSCopying,
                                  kPHONENUMBER as NSCopying
    ]) as! [String: Any]
    
}

func updateCurrentUser(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(withValues)
        
        // update user data on firebase
        FirebaseReference(.User).document(FUser.currentId()).updateData(withValues) { (error) in
            completion(error)
            
            if error == nil {
                saveUserLocally(userDictionary: userObject)
            }            
        }
    }
}
