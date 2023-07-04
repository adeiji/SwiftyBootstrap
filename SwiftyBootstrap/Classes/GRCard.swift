//
//  GRCard.swift
//  PMULibrary
//
//  Created by adeiji on 2019/3/28.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


public extension UIView {
    
    /// Creates a card set from a UIView object.  This card set can then be used to add to a GRCard for clean,
    /// simple layout purposes.  For more information look at the initializer for GRCardSet
    func toCardSet (height:CGFloat? = nil, name:String? = nil, newline:Bool = false) -> GRCardSet {
        return GRCardSet(
            content: self,
            height: height,
            newLine: newline,
            name: name)
    }        
}

open class Margin {
    
    public var bottomMargin:CGFloat? = 10.0
    public var topMargin:CGFloat? = 10.0
    
    
    /**
     
     When you add a left margin it will shrink the size of the element according to the size of the margin because the margin is relative to it's surrounding colum. Here is an example
     
     -----------------------------
     |    --------------------    |
     |    |                  |    |
     |    |     Element      |    |
     |    |                  |    |
     |    -------------------     |
     -----------------------------
     
     -----------------------------
     |             ------------   |
     |             |          |   |
     | |-margin-|  |  Element |   |
     |             |          |   |
     |             ------------   |
     -----------------------------
     
     */
    public var leftMargin:CGFloat? = 10.0
    
    /**
     
     When you add a right margin it will shrink the size of the element according to the size of the margin because the margin is relative to it's surrounding colum. Here is an example
     
     -----------------------------
     |    --------------------    |
     |    |                  |    |
     |    |     Element      |    |
     |    |                  |    |
     |    -------------------     |
     -----------------------------
     
     -----------------------------
     |   ------------            |
     |   |          |            |
     |   |  Element | |-margin-| |
     |   |          |            |
     |   ------------            |
     -----------------------------
     
     */
    public var rightMargin:CGFloat? = 10.0
    
    public var cardSet:GRCardSet
    
    public init(cardSet:GRCardSet) {
        self.cardSet = cardSet
    }
    
    public func bottom(_ value:CGFloat) -> GRCardSet {
        self.bottomMargin = value
        return self.cardSet
    }
    
    public func top(_ value:CGFloat) -> GRCardSet {
        self.topMargin = value
        return self.cardSet
    }
    
    public func left(_ value:CGFloat) -> GRCardSet {
        self.leftMargin = value
        return self.cardSet
    }
    
    public func right(_ value:CGFloat) -> GRCardSet {
        self.rightMargin = value
        return self.cardSet
    }
    
}
 
 
public typealias Column = GRBootstrapElement.Column
