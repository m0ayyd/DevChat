//
//  AuthService.swift
//  DevChat
//
//  Created by the Luckiest on 7/4/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

typealias Completion = (_ errorMessage: String?, _ data:Any?) -> Void

class AuthService {
    private static let _instance: AuthService = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil, let error = error as NSError? {
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    if errorCode == AuthErrorCode.userNotFound {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil, let error = error as NSError? {
                                // Show error to the user
                                self.handleFirebaseError(error: error, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    // Save user
                                    DataService.instance.saveUser(uid: (user?.uid)!)
                                    // SignIn
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil, let error = error as NSError? {
                                            // Show error to the user
                                            self.handleFirebaseError(error: error, onComplete: onComplete)
                                        } else {
                                            // we have successfully logged in
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                            
                            
                        })
                    }
                } else {
                    // Handle all other errors
                    self.handleFirebaseError(error: error, onComplete: onComplete)
                }
            } else {
                // Successfully login
                onComplete?(nil, user)
                
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid passwrd", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Couldn't create accoun email already in user", nil)
                break
                
            default:
                onComplete?("There was a problem with authenticating. Try again.", nil)
            }
        }
    }
    
    
}
