//
//  DataService.swift
//  brepoint
//
//  Created by Bela Mate Barandi on 4/8/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUserName(forUID uid: String, completion: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for user in userSnapshot {
                if user.key == uid {
                    completion(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(uid: String, withMessage message: String, withGroupKey groupKey: String?, completion: @escaping CompletionHandler) {
        if groupKey != nil {
            //send to group ref
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId" : uid])
            completion(true,nil)
        }
    }
    
    func getAllFeedMessages(completion: @escaping (_ messages: [Message]) -> ()) {
        
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for message in  feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            completion(messageArray)
        }
    }
    
    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            completion(emailArray)
        }
    }
    
    func getIds(forUsernames userNames: [String], completion: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var uidArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if userNames.contains(email) {
                    uidArray.append(user.key)
                }
            }
            completion(uidArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds uids: [String], completion: @escaping (_ success: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members":uids])
        completion(true)
        }
    
    func getAllGroups(completion: @escaping () -> ()) {
        
    }
    
    
    
    
    
    
    
}
