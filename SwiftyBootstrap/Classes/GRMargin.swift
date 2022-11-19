//
//  GRCard.swift
//  PMULibrary
//
//  Created by adeiji on 2019/3/28.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

/** This class is responsible for handling the margins of a card set. **/
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
        
    /// The card set that we're setting the margin for
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
