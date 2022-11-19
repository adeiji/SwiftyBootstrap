//
//  GRCurrentDevice.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/18/22.
//

import Foundation
import UIKit

open class GRCurrentDevice: UIViewController {
    
    public static let shared = GRCurrentDevice()
    
    /**
     This will change with every change of layout within the app.  My meaning is, that if the user goes from say portrait to landscape, then if on a phone, that change will be going from .xs to .sm and that change will be reflected here.
     
     Any time you need to recieve the current size class then retrieve it here
     */
    public var size:DeviceSizes = GRCurrentDevice.getScreenSize() {
        didSet {
            if oldValue != self.size {
                NotificationCenter.default.post(name: .ScreenSizeChanged, object: nil)
            }
        }
    }
    
    
    /// A convenience method to get the current top most view controller
    /// - Returns:The top most vieow controller
    public func getTopController () -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
    
    /** Get what the current screen size is, ex large, small, very large etc.  Currently on returns small or large */
    open class func getScreenSize () -> DeviceSizes {
        let width = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ?? UIApplication.shared.windows.first?.bounds.width ?? UIScreen.main.bounds.width
        
        switch width {
        case let x where x <= 450: // iPhone Width or the slim view of the iPad
            return .xs
        case let x where x <= 768: // less than iPad full width so half of screen in landscape if on an iPad Pro 12.9inch, on the normal size iPad this is portrait mode
            return .sm
        case let x where x > 768 && x < 1024: // It's the portrait of an iPad
            return .md
        case let x where x >= 1024 && x < 1366: // It's either a normal iPad landscape, or iPad Pro 12.9inch portrait
            return .lg
        default: // iPad Pro 12.9inch landscape
            return .xl
        }
    }
    
    /// If in landscape mode we need the width to be whatever the highest dimension is since unfortunately sometimes the height and
    /// the width values are switched.  So for example, in landscape if the height is reading as 1134 and the width 865, we know that we
    /// need to use the height value since in landscape width is always greater than height
    /// This works vice versa for portrait
    open class func getCorrectWidth () -> CGFloat {
                        
        let width = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ??  UIApplication.shared.windows.first?.bounds.width ?? UIScreen.main.bounds.width
        
        return width
    }
    
}

