//
//  NotificationExtensions.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/18/22.
//

import Foundation

extension Notification.Name {
    
    /// Notification for when the size of the screen has changes, this is for when the user goes from landscape to portrait, or when the device owner decides to use split screen
    public static let ScreenSizeChanged = NSNotification.Name("ScreenSizeChanged")
    
    /// When the app changes from light to dark or vice versa
    public static let UserInterfaceStyleChanged = NSNotification.Name("UserInterfaceStyleChanged")
}
