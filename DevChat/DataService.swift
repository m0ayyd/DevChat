//
//  DataService.swift
//  DevChat
//
//  Created by the Luckiest on 7/4/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

let FIR_DB_USERS_KEY = "users"
class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var usersRef: DatabaseReference {
        return mainRef.child(FIR_DB_USERS_KEY)
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://devchat-9a28a.appspot.com")
    }
    
    var imagesStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: StorageReference {
        return mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String) {
        let firstName = Auth.auth().currentUser?.email != nil ? Auth.auth().currentUser?.email : "Another User"
        let profile: [String: Any] = ["firstName": firstName! , "lastName": ""]
        
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo: [String:User], mediaURL: URL, textSnippet: String? = nil) {
        var uids: [String] = []
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        let pr : [String:Any] = ["mediaURL": mediaURL.absoluteString, "userID": senderUID, "openCount": 0, "recipients": uids]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
        
    }
    
    
}
