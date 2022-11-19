//
//  BootstrapMargin.swift
//  Pods
//
//  Created by Adebayo Ijidakinro on 5/4/20.
//

import Foundation
import UIKit

/**
 Margin that it used specifically within the GRBootstrapElement class.
 This is the outer margin of the object.
 */
public struct BootstrapMargin {
    let left:Margin
    let top:Margin
    let right:Margin
    let bottom:Margin
        
    public static let five: BootstrapMargin = BootstrapMargin(left: .Five, top: .Five, right: .Five, bottom: .Five)
    
    public static let four: BootstrapMargin = BootstrapMargin(left: .Four, top: .Four, right: .Four, bottom: .Four)
    
    public static let three: BootstrapMargin = BootstrapMargin(left: .Three, top: .Three, right: .Three, bottom: .Three)
    
    public static let two: BootstrapMargin = BootstrapMargin(left: .Two, top: .Two, right: .Two, bottom: .Two)
    
    public static let one: BootstrapMargin = BootstrapMargin(left: .One, top: .One, right: .One, bottom: .One)
    
    public static func none () -> BootstrapMargin {
        return BootstrapMargin(left: .Zero, top: .Zero, right: .Zero, bottom: .Zero)
    }
    
    public init (left:Margin = .One, top:Margin = .One, right:Margin = .One, bottom:Margin = .One) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public enum Margin:CGFloat {
        case Zero
        case One
        case Two
        case Three
        case Four
        case Five
        
    }

    /**
     Returns what the margin will be in pixels for the size class and the margin given
     */
    public static func getMarginInPixels (_ margin: Margin) -> CGFloat {
        
        let sizeClass = GRCurrentDevice.shared.size
        
        switch sizeClass {
        case .xs:
            return self.getMarginSize(interval: 1, margin: margin)
        case .sm:
            return self.getMarginSize(interval: 2, margin: margin)
        case .md:
            return self.getMarginSize(interval: 3, margin: margin)
        case .lg:
            return self.getMarginSize(interval: 4, margin: margin)
        default:
            return self.getMarginSize(interval: 5, margin: margin)
        }
    }

    /**
        Calculates what the size of the margin is given the margin enum value.
     
        - parameter margin: The margin enum value to calculate the size of the margin for
        - parameter interval: The interval is based of off the sizeClass, so a sizeClass of xs will have an interval of 1.  That interval is then used to calculate the size of the margin
     */
    private static func getMarginSize(interval: CGFloat, margin: Margin) -> CGFloat {
        switch margin {
        case .Zero:
            return 0
        case .One:
            return interval * 2
        case .Two:
            return interval * 4
        case .Three:
            return interval * 6
        case .Four:
            return interval * 8
        default:
            return interval * 10
        }
    }
}

