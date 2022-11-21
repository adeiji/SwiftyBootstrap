//
//  GRCardSet.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 8/10/22.
//

import Foundation


/// A card set is used by GRBootstrapElement to layout UI elements on the screen using rows and columns.
open class GRCardSet {
        
    /// The content that is to be stored in this card set
    public let content:UIView
    
    /// Newline is calculated in the addColumns method of the Row class. It is the indicator for whether to put this card (column) on a new line or not.  You should never have to set this manually.  If you want a column/card to be on a new line then use the addRow(column: []) function of the GRBootstrapElement class
    public var newLine:Bool
        
    /// Whether or not this card set should be a square
    private var isSquare:Bool
        
    /// The height of the content of this card set
    internal var height:CGFloat?
    
    /// Whether to anchor the content of this view to the view that's directly above it
    internal var anchorToViewAbove:Bool?
    
    // The margin is sure to be set in the initializer, but if we don't say that this value can be null than we can't assign the margin's card set to self since margin relies on self and you'll get an error saying trying to access self before all required properties are set
    open var margin:Margin!
    
    /// The name of this card set
    open var name:String?
    
    /// Initialize the GRCardSet object
    ///
    /// - Parameters:
    ///   - content: The view to associate with the card
    ///   - width: The width of the view, in increments of 1.0.  With 1.0 being the smallest, and 12.0 being full screen
    ///   - height: The height in pixels of the view
    ///   - newLine: Whether you want this card to appear on a new line or on the same line with the previous card
    ///   - shouldOverlay: Should you overlay this object to it's superview
    ///   - name: The name of the element, this is important if you need to debug, you can use this name to know which element is being looked at when debugging.
    public init(content: UIView, height:CGFloat? = nil, newLine: Bool = true, name: String? = nil, isSquare: Bool = false) {
        self.content = content
        self.height = height
        self.newLine = newLine
        self.name = name
        self.isSquare = isSquare
        
        self.margin = Margin(cardSet: self)
    }
    
    /// Set height of this card set
    /// - Parameter height: The height you want the card set
    /// - Returns: The card set (self)
    open func withHeight(_ height: CGFloat) -> GRCardSet {
        self.height = height
        
        return self
    }
    
    
    /// Sets if this card set is square or not
    /// - Parameter isSquare: Whether or not the card is a square
    /// - Returns: The card set (self)
    open func isSquare (_ isSquare: Bool) -> GRCardSet {
        self.isSquare = isSquare
        return self
    }
        
    /// Returns whether or not this card set is a square
    open func getIsSquare () -> Bool {
        return self.isSquare
    }
    
    /// Sets the name of this card set
    /// - Parameter name: The name you want to give the card set
    /// - Returns: The card set (self)
    open func withName(_ name: String?) -> GRCardSet {
        self.name = name
        
        return self
    }

    
    /// Sets whether or not to anchor this cardset's content to the view above it
    /// - Parameter shouldAnchor: Whether or not to anchor this content's view to the view above it
    /// - Returns: The card set (self)
    open func anchorToViewAbove (_ shouldAnchor: Bool) -> GRCardSet {
        self.anchorToViewAbove = shouldAnchor
        return self
    }
}

public extension UIView {
    
    /// Creates a card set from a UIView object.  This card set can then be used to add to a GRCard for clean,
    /// simple layout purposes.  For more information look at the initializer for GRCardSet
    func cardSet (height:CGFloat? = nil, name:String? = nil, newline:Bool = false) -> GRCardSet {
        return GRCardSet(
            content: self,
            height: height,
            newLine: newline,
            name: name)
    }
}
