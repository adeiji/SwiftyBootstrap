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
    public var username:String
    
    // The id of the user
    public var userId:String
    
    /// The documentId of this user in Firestore.  This should match the userId
    public var documentId:String
    
    /// The profile picture of the user
    public var profilePicture:UIImage?
    
    /// The url of the profile picture of the user
    public var profilePictureUrl:URL?
    
    /// The user's phone number
    public var phone:String?
    
    /// The user's first name
    public var firstName:String?
    
    /// The user's last name
    public var lastName:String?
    
    /// Whether or not this user has been blocked
    public var isBlocked:Bool?
    
    /// Whether or not this user has been reported
    public var isReported:Bool?
    
    /// Whether or not this user is active
    public var isActive:Bool?
    
    /// The Id of the device that this user is using
    public var deviceId:String?

    /// The number of people this user is following
    public var followingCount:Int?
    
    /// The number of people this user is being followed by
    public var followerCount:Int?

    /// The bio that the user wrote for themselves
    public var bio:String?

    /// A list of userIds that the user has blocked
    public var blockedUsers:[String] = [String]()
}
