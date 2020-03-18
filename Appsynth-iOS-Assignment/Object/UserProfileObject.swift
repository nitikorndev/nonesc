//
//  UserProfile.swift
//  Appsynth-iOS-Assignment
//
//  Created by Sujin Chaichanamongkol on 17/3/2563 BE.
//  Copyright © 2563 Sujin Chaichanamongkol. All rights reserved.
//

import Foundation

class UserProfileObject: Codable, Equatable {
    static func == (lhs: UserProfileObject, rhs: UserProfileObject) -> Bool {
        if lhs.userId == rhs.userId {
            return true
        }
        return false
    }
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    var followers: Int?
    var following: Int?
    var likes: Int?
    
    
}
