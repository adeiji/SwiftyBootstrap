//
//  GRUser.swift
//  Graffiti
//
//  Created by adeiji on 4/10/18.
//  Copyright © 2018 Dephyned. All rights reserved.
//

import Foundation
import UIKit

public enum UserError : Error {
    case documentDoesntContainNecessaryParameters(message: String)
    case UserNotLoggedIn
}
/**
 A basic Swift class representing a Graffiti user
 */
public struct GRUser {
    
    /// The username of the user
    var username:String
    
    // The id of the user
    var userId:String
    
    /// The documentId of this user in Firestore.  This should match the userId
    var documentId:String
    
    /// The profile picture of the user
    var profilePicture:UIImage?
    
    /// The url of the profile picture of the user
    var profilePictureUrl:URL?
    
    /// The user's phone number
    var phone:String?
    
    /// The user's first name
    var firstName:String?
    
    /// The user's last name
    var lastName:String?
    
    /// Whether or not this user has been blocked
    var isBlocked:Bool?
    
    /// Whether or not this user has been reported
    var isReported:Bool?
    
    /// Whether or not this user is active
    var isActive:Bool?
    
    /// The Id of the device that this user is using
    var deviceId:String?

    /// The number of people this user is following
    var followingCount:Int?
    
    /// The number of people this user is being followed by
    var followerCount:Int?

    /// The bio that the user wrote for themselves
    var bio:String?

    /// A list of userIds that the user has blocked
    var blockedUsers:[String] = [String]()


}
