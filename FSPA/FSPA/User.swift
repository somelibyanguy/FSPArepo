//
//  User.swift
//  SignUp
//
//  Created by Abdulrahman Ayad on 10/22/19.
//  Copyright © 2019 Abdulrahman Ayad. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {
    
    // MARK: - Properties
    
    let uid: String
    
    let fullName: String
    
    // MARK: - Init
    
    init(uid: String, fullName: String) {
        
        self.uid = uid
        
        self.fullName = fullName
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String : Any],
            let fullName = dict["fullName"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        
        self.fullName = fullName
        
    }
    
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        
        // 3
        
        guard let currentUser = _current else {
            
            fatalError("Error: current user doesn't exist")
            
        }
        
        // 4
        
        return currentUser
        
    }
    
    // MARK: - Class Methods
    
    // 5
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            
            // 3
            
            if let data = try? JSONEncoder().encode(user) {
                
                // 4
                
                UserDefaults.standard.set(data, forKey: "currentUser")
                
            }
            
        }
        
        _current = user
        
    }
    
}
