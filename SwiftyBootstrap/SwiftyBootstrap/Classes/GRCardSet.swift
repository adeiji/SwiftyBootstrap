//
//  GRCardSet.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 8/10/22.
//

import Foundation

open class GRCardSet {
    
    public let content:UIView
    /// Newline is calculated in the addColumns method of the Row class. It is the indicator for whether to put this card (column) on a new line or not.  You should never have to set this manually.  If you want a column/card to be on a new line then use the addRow(column: []) function of the GRBootstrapElement class
    public var newLine:Bool
    private var isSquare:Bool
    public var height:CGFloat?
    public var anchorToViewAbove:Bool?
    
    // The margin is sure to be set in the initializer, but if we don't say that this value can be null than we can't assign the margin's card set to self since margin relies on self and you'll get an error saying trying to access self before all required properties are set
    open var margin:Margin!
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
    
    open func withHeight(_ height: CGFloat) -> GRCardSet {
        self.height = height
        
        return self
    }
    
    open func isSquare (_ isSquare: Bool) -> GRCardSet {
        self.isSquare = isSquare
        return self
    }
    
    open func getIsSquare () -> Bool {
        return self.isSquare
    }
    
    open func withName(_ name: String?) -> GRCardSet {
        self.name = name
        
        return self
    }
    
    open func anchorToViewAbove (_ shouldAnchor: Bool) -> GRCardSet {
        self.anchorToViewAbove = shouldAnchor
        return self
    }
}
