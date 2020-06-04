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
    
    fileprivate var bottomMargin:CGFloat? = 10.0
    fileprivate var topMargin:CGFloat? = 10.0
    

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
    fileprivate var leftMargin:CGFloat? = 10.0
    
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
    fileprivate var rightMargin:CGFloat? = 10.0
    
    fileprivate var cardSet:GRCardSet
    
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

public enum ColWidth:CGFloat {
    case Zero = 0.0 // Don't add to the superview
    case One = 1.0
    case Two = 2.0
    case Three = 3.0
    case Four = 4.0
    case Five = 5.0
    case Six = 6.0
    case Seven = 7.0
    case Eight = 8.0
    case Nine = 9.0
    case Ten = 10.0
    case Eleven = 11.0
    case Twelve = 12.0
}


open class GRCardSet {
    
    public let content:UIView
    /// Newline is calculated in the addColumns method of the Row class. It is the indicator for whether to put this card (column) on a new line or not.  You should never have to set this manually.  If you want a column/card to be on a new line then use the addRow(column: []) function of the GRBootstrapElement class
    fileprivate var newLine:Bool
    private var isSquare:Bool
    fileprivate var height:CGFloat?
    fileprivate var anchorToViewAbove:Bool?
    
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



/// A GRCard is a basically a container that contains elements organized in a very specific way
/// They can be stacked horizontally or vertically
/// A GRCard differs from a Stack View in that a Stack View is used to split a view into equal sizes whereas a GRCard can have elements of all sizes
/// organized within it.
/*:
    How to use the card
 
    
    
    let card = GRCard(color: .white)
    card.addElements(elements: [cardSet1, cardSet2])
    card.addToSuperview(superview: self.view, margin: Sizes.smallMargin.rawValue, viewAbove:nil, anchorToBottom:false)
 */
open class GRBootstrapElement : UIView {
    
    open weak var header:UIView?
    
    /// The top constraint of the card.
    open weak var topConstraint:Constraint?
    
    open weak var viewAbove: UIView?
    
    /// Whether or not this card should be anchored to the bottom of it's superview
    open var anchorToBottom:Bool?
    /// The elements that are shown on this card.
    internal var elements:[GRCardSet] = [GRCardSet]()
    
    /// Whether or line up the contents of this card horizontally
    open var horizontalLayout:Bool = false
    
    /// Whether to set the maximum width of this card to the width of the screen.  If this is set to **true** then cards that will go beyond the width of the screen will automatically be pushed to the next line.
    open var anchorWidthToScreenWidth:Bool
    
    /**
     Whether or not to anchor the last element in the elements array to the bottom of the card.
     
     An instance where you would not want this is if you have a card inside of a scroll view with a fixed height.  Since the height is fixed you wouldn't need to worry about anchoring the last element to the bottom because that's usually done if you need a view to expand vertically based on it's subviews.  Typically this should be set to true.
     
     If you find that you have a scroll view with this card as the subview, and the card's horizontalLayout is set to true, and the last element's height is different than what you were expecting, it's probably because this value was set to true.
     */
    open var anchorLastElementToBottom:Bool = true
    
    open var rows:[Row] = [Row]()
    
    /// The margin of the card when it's added to the superview
    public let margin:BootstrapMargin
    
    /// This is the view that this view will be a subview of. Set this value if you want this object to have it's width based off the width
    /// of the superview.  This is not needed if the width of this card/element is the width of the screen
    private let customSuperview:UIView?
    
    private var touchPoint:CGPoint?
    
    public init(color: UIColor? = .white, anchorWidthToScreenWidth:Bool = true, margin:BootstrapMargin? = nil, superview: UIView? = nil) {
        self.anchorWidthToScreenWidth = anchorWidthToScreenWidth
        self.margin = margin ?? BootstrapMargin()
        self.customSuperview = superview
        self.customSuperview?.layoutIfNeeded()
        super.init(frame: .zero)
        if let color = color {
            self.backgroundColor = color;
        } else {
            self.backgroundColor = .white
        }
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        GRCurrentDevice.shared.size = Style.getScreenSize()
        self.redoConstraints()
    }
        
    required public init?(coder aDecoder: NSCoder) {
        self.anchorWidthToScreenWidth = true
        self.margin = BootstrapMargin()
        self.customSuperview = nil
        super.init(coder: aDecoder)
    }
    
    /**
     Redo all the constraints
     This should typically be called when the orientation of the device changes
     */
    private func redoConstraints () {
        self.rows.forEach { [weak self] (row) in
            guard let self = self else { return }
            row.widthInPixels = self.customSuperview?.bounds.width ?? (Style.getCorrectWidth() * row.getWidthRatio())
            row.redraw()
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let view = super.hitTest(point, with: event)
        
        if view == self {
            return nil
        }
        
        if view is UILabel || view is UIImageView {
            return nil
        }

        return view
    }
        
    @discardableResult open func addRow (columns:[Column], widthInPixels:CGFloat? = nil, anchorToBottom myAnchorToBottom:Bool = false) -> GRBootstrapElement {
        let row = Row()
        self.addSubview(row)
        row.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self.rows.last?.snp.bottom ?? self)
            
            if (myAnchorToBottom == true) {
                make.bottom.equalTo(self)
            }
        }
        
        if let widthInPixels = widthInPixels {
            row.widthInPixels = widthInPixels
        } else if let superview = self.customSuperview {
            row.widthInPixels = superview.bounds.width
        }
        
        let leftMargin = BootstrapMargin.getMarginInPixels(self.margin.left)
        let rightMargin = BootstrapMargin.getMarginInPixels(self.margin.right)
        
        row.widthInPixels = row.widthInPixels - leftMargin - rightMargin
        row.addColumns(columns: columns, margin: self.margin)
        self.rows.append(row)
        
        return self
    }
    
    open class func getCaptionHeaderView (title: String, subtitle: String, alignment: NSTextAlignment) -> (titleLabel: UILabel, subtitleLabel: UILabel, view: UIView) {
        
        let titleLabel = Style.label(withText: title, fontName: .allBold, size: .medium, superview: nil, color: .black, numberOfLines: 0, textAlignment: alignment)
        let subtitleLabel = Style.label(withText: subtitle, fontName: .allBold, size: .small, superview: nil, color: .darkGray, numberOfLines: 0, textAlignment: alignment)
        
        // View at the top that holds the location and the spot name
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        // Setup constraints for the location label
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerView)
            make.right.equalTo(headerView)
            make.top.equalTo(headerView)
        }
        
        // setup constraints for the spot name label
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(-5)
            make.bottom.equalTo(headerView)
        }
        
        return (titleLabel: titleLabel, subtitleLabel: subtitleLabel, view: headerView)
    }
    
    // This is the constraint that attaches the last element to the bottom of the Card
    open var bottomConstraint:Constraint?
    
    open func slideDownAndRemove (superview: UIView) {
        
        if let topConstraint = self.topConstraint {
            topConstraint.update(offset: 5000)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            superview.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    open func slideUpAndRemove (superview: UIView) {
        
        if let topConstraint = self.topConstraint {
            topConstraint.update(offset: -5000)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            superview.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /// Slide the card up from the bottom of the screen, and adds the view to the superview
    ///
    /// - Parameters:
    ///   - superview: Add the card to this superview
    ///   - margin: The margins relative to the superview
    open func slideDown (superview:UIView, margin: CGFloat, width: CGFloat? = nil, forTimeInterval timeInterval: TimeInterval? = nil) {
        
        if let timeInterval = timeInterval {
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
                self.slideUpAndRemove(superview: superview)
            }
        }
        
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            
            if let width = width {
                make.width.equalTo(width)
                make.centerX.equalTo(superview)
            } else {
                make.left.equalTo(superview).offset(margin)
                make.right.equalTo(superview).offset(-margin)
            }
            
            make.bottom.equalTo(superview.snp.top)
        }
        
        superview.layoutIfNeeded()
        
        self.snp.remakeConstraints { (make) in
            if let width = width {
                make.width.equalTo(width)
                make.centerX.equalTo(superview)
            } else {
                make.left.equalTo(superview).offset(margin)
                make.right.equalTo(superview).offset(-margin)
            }
            
            self.topConstraint = make.top.equalTo(superview).offset((Sizes.smallMargin.rawValue * 3.0) + margin).constraint
        }
        
        UIView.animate(withDuration: 0.2) {
            superview.layoutIfNeeded()
        }
    }
    
    
    /// Slide the card up from the bottom of the screen, and adds the view to the superview
    ///
    /// - Parameters:
    ///   - superview: Add the card to this superview
    ///   - margin: The margins relative to the superview
    ///   - width: If you want this to have a unique width, than set this value yourself.
    open func slideUp (superview:UIView, margin: CGFloat = 0, width: CGFloat? = nil, timeInterval: TimeInterval? = nil) {
        
        if let timeInterval = timeInterval {
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
                self.slideDownAndRemove(superview: superview)
            }
        }
        
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            
            if let width = width {
                make.width.equalTo(width)
                make.centerX.equalTo(superview)
            } else {
                make.left.equalTo(superview).offset(margin)
                make.right.equalTo(superview).offset(-margin)
            }
                        
            make.top.equalTo(superview.snp.bottom)
        }
        
        superview.layoutIfNeeded()
        
        self.snp.remakeConstraints { (make) in
            if let width = width {
                make.width.equalTo(width)
                make.centerX.equalTo(superview)
            } else {
                make.left.equalTo(superview).offset(margin)
                make.right.equalTo(superview).offset(-margin)
            }
            self.topConstraint = make.bottom.equalTo(superview).offset(-margin).constraint
        }
        
        UIView.animate(withDuration: 0.2) {
            superview.layoutIfNeeded()
        }
    }
    
    
    /// Add the card to a view
    ///
    /// - Parameters:
    ///   - superview: The view to add the card to
    ///   - margin: The margin for the view
    ///   - viewAbove: If there is a view you want this card to be below
    ///   - anchorToBottom: Whether the card should be anchored to the bottom of the view
    open func addToSuperview (superview: UIView, viewAbove: UIView? = nil, anchorToBottom:Bool = false) {
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            
            let leftMargin = BootstrapMargin.getMarginInPixels(self.margin.left)
            let rightMargin = BootstrapMargin.getMarginInPixels(self.margin.right)
            
            make.left.equalTo(superview).offset(leftMargin)
            make.right.equalTo(superview).offset(-(rightMargin))
            
            if let viewAbove = viewAbove {
                self.topConstraint = make.top.equalTo(viewAbove.snp.bottom).offset(BootstrapMargin.getMarginInPixels(self.margin.top)).constraint
            } else {
                let topMargin = BootstrapMargin.getMarginInPixels(self.margin.top)
                self.topConstraint = make.top.equalTo(superview).offset(topMargin).constraint
            }
            
            if anchorToBottom {
                let bottomMargin = BootstrapMargin.getMarginInPixels(self.margin.bottom)
                make.bottom.equalTo(superview).offset(-(bottomMargin))
            }
        }
        
        self.viewAbove = viewAbove
        self.anchorToBottom = anchorToBottom
        
    }
    
    /// Adds a header to the card of type UILabel
    ///
    /// - Parameter label: The label to add as the header
    open func setHeader (header: String) {
        
        let label = Style.label(withText: header, superview: self, color: .black);
        self.header = label;
        
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.top.equalTo(self).offset(Sizes.smallMargin.rawValue)
        }
        
        label.text = header;
    }
    
    open func redraw () {
        guard
            let superview = self.superview
            else {
                assertionFailure()
                return
        }
        
        self.removeFromSuperview()
        self.elements = [GRCardSet]()

        self.addToSuperview(
            superview: superview,
            viewAbove: self.viewAbove,
            anchorToBottom: self.anchorToBottom ?? false)
    }
    
    open func removeElements () {
        self.elements.forEach { (element) in
            element.content.removeFromSuperview()
        }
        
        self.elements = []
    }
    
    open func getElementNamed (_ name: String, superCardElements:[GRCardSet]? = nil) -> GRCardSet? {
        return self.getOrRemoveItemWithName(name, elements: self.elements, superCardElements: superCardElements)
    }
    
    @discardableResult
    private func getOrRemoveItemWithName (_ name: String, elements: [GRCardSet], superCardElements:[GRCardSet]? = nil, cardToRemoveElementFrom:GRBootstrapElement? = nil, shouldRemoveCard:Bool = false) -> GRCardSet? {
        
        var myElements = elements
        if myElements.count > 0 {
            
            let element = myElements.removeFirst()
            
            if element.name == name {
                if shouldRemoveCard {
                    element.content.removeFromSuperview()
                    cardToRemoveElementFrom?.elements.removeAll { $0.name == element.name }
                    cardToRemoveElementFrom?.redraw()
                }
                
                return element
            } else {
                // If we've reached the last element, than check to see if this current element has a parent card, and if so then search it's elements
                if myElements.count == 0 {
                    if
                        let superCard = element.content.superview?.superview as? GRBootstrapElement,
                        let superCardElements = superCardElements
                    {
                        return getOrRemoveItemWithName(
                            name,
                            elements: superCardElements,
                            cardToRemoveElementFrom: superCard,
                            shouldRemoveCard: shouldRemoveCard)
                    }
                }
                
                if let card = element.content as? GRBootstrapElement {
                    return getOrRemoveItemWithName(
                        name,
                        elements: card.elements,
                        superCardElements: myElements,
                        cardToRemoveElementFrom: card,
                        shouldRemoveCard: shouldRemoveCard)
                } else {
                    return getOrRemoveItemWithName(
                        name,
                        elements: myElements,
                        superCardElements: superCardElements,
                        cardToRemoveElementFrom: cardToRemoveElementFrom,
                        shouldRemoveCard: shouldRemoveCard)
                }
            }
        }
    
        return nil
    }
    
    open func removeElementNamed (_ name: String) {
        self.getOrRemoveItemWithName(
            name,
            elements: self.elements,
            cardToRemoveElementFrom: self,
            shouldRemoveCard: true)
    }
    
    /// Add an element to the card.
    /// This function adds the card to the end of the elements array *IF* you don't input anything for the atIndex parameter.
    /// If this card has already been added to a view than you will need to call the redraw() method
    ///
    /// - Parameter element: The element to add to the card
    open func addElement (element: GRCardSet, atIndex:Int? = nil) {
        if let bottomConstraint = self.bottomConstraint {
            bottomConstraint.deactivate()
        }
        
        if let index = atIndex {
            self.elements.insert(element, at: index)
        } else {
            self.elements.append(element);
        }
        
//        self.addElements(elements: self.elements);
    }
    
        
    /// Show a card at the bottom of the screen that shows that an action was a success
    ///
    /// - Parameters:
    ///   - message: The message to show the user
    ///   - superview: The view to add the card to
    /// - Returns: The card
    @discardableResult
    open class func showMessageCard (message: String, superview: UIView, isError:Bool, slideUpFromBottom:Bool, customCardBackgroundColor:UIColor? = nil, textColor:UIColor? = nil, addBlurView: Bool = true, showForTimeInterval:TimeInterval = 0, closeButtonText: String) -> GRBootstrapElement {
                
        var cardBackgroundColor:UIColor!
        
        if isError {
            cardBackgroundColor = .red
        } else {
            if let color = customCardBackgroundColor {
                cardBackgroundColor = color
            } else {
                cardBackgroundColor = .black
            }
        }
        
        let messageCard = GRBootstrapElement(color: cardBackgroundColor)
        
        let closeButton = Style.largeButton(with: closeButtonText, superview: nil, backgroundColor: UIColor.Style.orange)
        if isError {
            closeButton.backgroundColor = .black
        }

        messageCard.addRow(columns: [
            Column(cardSet: Style.label(withText: message, size: .small, superview: nil, color: textColor ?? .white)
                .toCardSet(),
                   xsColWidth: .Eleven)
            ]).addRow(columns: [
                Column(cardSet: closeButton
                    .toCardSet()
                    .margin.top(40)
                    .withHeight(70.0),
                       xsColWidth: .Five)
            ], anchorToBottom: true)
        
        if slideUpFromBottom {
            messageCard.slideUp(superview: superview, margin: Sizes.smallMargin.rawValue)
        } else {
            messageCard.slideDown(superview: superview, margin: Sizes.smallMargin.rawValue)
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = superview.bounds
        blurEffectView.isUserInteractionEnabled = false
        
        if addBlurView {
            superview.addSubview(blurEffectView)
        }
        
        closeButton.addTargetClosure { (_) in
            if addBlurView {
                blurEffectView.removeFromSuperview()
            }
            
            if (slideUpFromBottom) {
                messageCard.slideDownAndRemove(superview: superview)
            } else {
                messageCard.slideUpAndRemove(superview: superview)
            }
        }
        
        if showForTimeInterval > 0 {
            let _ = Timer.scheduledTimer(withTimeInterval: showForTimeInterval, repeats: false) { (_) in
                if (slideUpFromBottom) {
                    messageCard.slideDownAndRemove(superview: superview)
                } else {
                    messageCard.slideUpAndRemove(superview: superview)
                }
            }
        }
        
        messageCard.layer.zPosition = 100
        return messageCard
    }
    
    open class ActionCard: GRBootstrapElement {
        open weak var actionButton:UIButton?
        open weak var cancelButton:UIButton?
    }
    
    open class Row: UIView {
        
        private var columns = [Column]()
        
        /// The width of this row in pixels
        open var widthInPixels = Style.getCorrectWidth() {
            didSet {
                if self.widthRatio == nil
                {
                    // We need to get the correct ratio of this row's width in comparison to the width of the device in order to make sure that when
                    // the user rotates the device we still keep the same ratio for this row.  For example:
                    // If this row's width is 500 and the Device width is 1000, that means that the row's width is 1/2 of the screen width
                    // When the user rotates, we want the row to still be 1/2 of the new screen width.
                    // So if the new screen width is 2000, the row width should be 1000
                    self.widthRatio = self.widthInPixels / Style.getCorrectWidth()
                }
                
            }
        }
        
        open var anchorWidthToScreenWidth:Bool = true
        
        open var anchorLastElementToBottom = true
        
        open var horizontalLayout = true
        
        open var bottomConstraint:Constraint?
        
        open var margin:BootstrapMargin?
        
        private var widthRatio:CGFloat!
        
        open func getWidthRatio () -> CGFloat {
            return self.widthRatio
        }
                        
        open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

            let view = super.hitTest(point, with: event)
            
            if view == self {
                return nil
            }
            
            if view is UILabel || view is UIImageView {
                return nil
            }

            return view
        }
        
        /**
         Add a list of elements to the Card.  This should only be called once.  If there are already elements in this Card than instead use the addElement function which will only add 1 element
         
         - parameter elements: The card sets to add to the card
         - returns: A GRCard object which can be ignored if desired
         */
        open func addColumns (columns: [Column], margin: BootstrapMargin?) {
            
            // Store this margin for later, we'll need it when we need to redraw the elements on a screen resize
            self.margin = margin
            
            var columns = columns
            
            // If there's no columns than exit out this function.
            if columns.first == nil {
                return
            }
            
            // Store the columns so that we can redraw them later if necessary
            if (self.columns.count == 0) {
                self.columns.append(contentsOf: columns)
            }
            // If the column is set to zero for the current size class, than we don't want to add it to the superview and process it's constraints
            // right now.  The reason this method comes after we've assigned it to the self.columns property is because we still need to keep
            // a reference to this column because later if the screen size is changed, than we have to have access to this column in order to
            // draw it, or to remove it again
            columns.removeAll(where: { self.getCorrectSizeClass(column: $0) == .Zero })
            
            var columnAbove = columns.first!
            var currentXPos:CGFloat = 0
            
            for index in 0...columns.count - 1 {
                // Make sure that the content hasn't accidentally been added to a view already, if so, remove the column it's a subview of
                columns[index].cardSet.content.superview?.removeFromSuperview()
                let column = columns[index]
                if self.getCorrectSizeClass(column: column) == .Zero {
                    continue
                }
                
                self.addSubview(column)
                self.addColumnConstraints(column: column, index: index, columnAbove: &columnAbove, currentXPos: &currentXPos)
            }
            
            return
        }
        
        public func redraw () {
            guard var columnAbove = columns.first else { return }
            var currentXPos:CGFloat = 0
            
            for index in 0...columns.count - 1 {
                let column = self.columns[index]
                
                // If when drawn initially, (before a change of size class) this column was set to draw on a new line, we want to reset it because it might not need to depending on the current size of the screen.  ie, if the screen size has changed then perhaps this element used to be added to a new line, but now it will be on the same line as it's previous column
                column.cardSet.newLine = false
                
                if self.getCorrectSizeClass(column: column) == .Zero {
                    continue
                }
                // Since there are times where a column will have a width of .Zero, or basically shouldn't be added for a specific size, we must
                // check to see if each column is actually added and if not then we add it now
                if column.superview == nil {
                    self.addSubview(column)
                }
                
                if index > 0 && self.getCorrectSizeClass(column: self.columns[index - 1]) == .Twelve {
                    column.cardSet.newLine = true
                }
                
                self.addColumnConstraints(column: column, index: index, columnAbove: &columnAbove, currentXPos: &currentXPos)
            }
        }
        
        /**
         We only want to have the user enter size classes up to the largest one without having to enter size classes for all classes in between
         What I mean is this...
         
         If the user wants the .sm and .xs size classes to use a column of .Six, than they should only need to set .Six for .sm, not for
         .sm and .xs.  We'll automatically apply the same size class to .xs if a value for .xs has not been entered
         
         If a value of .Two is entered for .sm and .Four for .lg then the value of .Two will be applied to .sm and .xs and the value of
         .Four will be applied to .lg and .md
         */
        private func getCorrectSizeClass (column: Column) -> ColWidth {
            let sizeClass = GRCurrentDevice.shared.size
            switch sizeClass {
            case .xl:
                return column.columnWidthForClassSizes[sizeClass]
                    ?? column.columnWidthForClassSizes[.lg]
                    ?? column.columnWidthForClassSizes[.md]
                    ?? column.columnWidthForClassSizes[.sm]
                    // We unwrap here because the default value is xs which always has a default value of .Twelve if no value is given to it
                    ?? column.columnWidthForClassSizes[.xs]!
            case .lg:
                return column.columnWidthForClassSizes[sizeClass]
                ?? column.columnWidthForClassSizes[.md]
                ?? column.columnWidthForClassSizes[.sm]
                // We unwrap here because the default value is xs which always has a default value of .Twelve if no value is given to it
                ?? column.columnWidthForClassSizes[.xs]!
            case .md:
                return column.columnWidthForClassSizes[sizeClass]
                ?? column.columnWidthForClassSizes[.sm]
                // We unwrap here because the default value is xs which always has a default value of .Twelve if no value is given to it
                ?? column.columnWidthForClassSizes[.xs]!
            case .sm:
                return column.columnWidthForClassSizes[sizeClass]
                // We unwrap here because the default value is xs which always has a default value of .Twelve if no value is given to it
                ?? column.columnWidthForClassSizes[.xs]!
            default:
                // We unwrap here because the default value is xs which always has a default value of .Twelve if no value is given to it
                return column.columnWidthForClassSizes[.xs]!
            }
        }
        
        private func addColumnConstraints (column: Column, index:Int, columnAbove: inout Column, currentXPos: inout CGFloat) {
             
            let colWidth = self.getCorrectSizeClass(column: column)
            
            let width = self.getWidth(width: colWidth.rawValue)
            column.widthInPixels = width
            
            // If this element is not to span across the entire screen, than we need to check to see if this element is going to go past the screen on the right side
            // and if so, set the elements newLine property to true so that it will display on a new line...
            if colWidth != .Twelve {
                                                
                if currentXPos + width > self.widthInPixels {
                    column.cardSet.newLine = true
                    currentXPos = 0
                }
            } else if (colWidth == .Twelve) {
                column.cardSet.newLine = true
            }
            
            // If this is the first element in the card than it's new line property should be set to true
            if column.cardSet.content == columns.first?.cardSet.content {
                column.cardSet.newLine = true
                currentXPos = 0
            }
            
            column.snp.remakeConstraints({ (make) in
                self.setCardSetsTopConstraint(column: column, columnAbove: &columnAbove, index: index, make: make, currentXPos: &currentXPos)
                self.setCardSetsLeftConstraint(column: column, index: index, make: make, currentXPos: &currentXPos)
                self.setHeight(column: column, make: make)
                self.setWidthOrRightConstraint(column: column, make: make, colWidth: colWidth, currentXPos: &currentXPos)
                self.setBottomConstraint(column: column, make: make)
            })
        }
        
        private func setBottomConstraint (column:Column, make:ConstraintMaker) {
            // Set the bottom element
            if ((column.cardSet.content == columns.last?.cardSet.content && self.anchorLastElementToBottom == true) || column.anchorToBottom == true) {
                self.bottomConstraint = make.bottom.equalTo(self).offset((column.cardSet.margin.bottomMargin ?? 0) * -1).constraint
            }
        }
        
        private func setWidthOrRightConstraint (column: Column, make:ConstraintMaker, colWidth:ColWidth, currentXPos:inout CGFloat) {
            // WIDTH OR RIGHT CONSTRAINT
            // Set the right contraint or the width.  If the element is full screen and we want to show the margins than we set the right constraint, otherwise we set the elements width
            if (self.horizontalLayout && colWidth != .Twelve) {
                make.width.equalTo(column.widthInPixels)
                currentXPos += column.widthInPixels
            }
            else if (colWidth == .Twelve) {
                make.right.equalTo(self)
            } else {
                if colWidth != .Twelve {
                    make.width.equalTo(column.widthInPixels)
                    currentXPos += column.widthInPixels
                } else {
                    make.width.equalTo(self)
                    currentXPos = 0
                }
            }
        }
        
        private func setHeight (column: Column, make:ConstraintMaker) {
            // If element is a text field than give it a specific height
            if (column.cardSet.content.isKind(of: UITextField.self)) {
                make.height.equalTo(column.cardSet.height ?? 50)
            } else if column.cardSet.getIsSquare() {
                make.height.equalTo(column.cardSet.content.snp.width)
            } else if let height = column.cardSet.height {
                make.height.equalTo(height)
            }
        }
        
        private func setCardSetsTopConstraint (column: Column, columnAbove:inout Column, index: Int, make:ConstraintMaker, currentXPos:inout CGFloat) {
                          
            if (column.cardSet.anchorToViewAbove == false) {
                return
            }
            
            if (column.cardSet.content == columns.first?.cardSet.content) {
                // Set the top of this element relative to the card's top
                make.top.equalTo(self).offset((column.cardSet.margin.topMargin ?? 0))
            } else {
                if column.cardSet.newLine {
                    // Place this element below the previous element
                    make.top.equalTo(columnAbove.cardSet.content.snp.bottom).offset((column.cardSet.margin.topMargin ?? 0) + (columnAbove.cardSet.margin.bottomMargin ?? 0))
                    columnAbove = column
                } else {
                    // Set the top of this element to be the same as the element preceding it
                    make.top.equalTo(columns[index - 1].cardSet.content.superview ?? 0)
                }
            }
        }
        
        private func setCardSetsLeftConstraint (column: Column, index: Int, make:ConstraintMaker, currentXPos:inout CGFloat) {
            if (column.cardSet.newLine || index == 0) {
                // Set the left margins relative to the card
                make.left.equalTo(self)
            } else {
                make.left.equalTo(columns[index - 1].snp.right)
            }
        }
        
        open func getWidth (width: CGFloat) -> CGFloat {
            let fullSizeWidth =  self.widthInPixels
            let screenColSize = fullSizeWidth / 12.0
                
            return width * screenColSize;
            
        }
        
    }
    
    open class Column: UIView {
        
        open var cardSet:GRCardSet
        
        open var widthInPixels: CGFloat!
        /**
         This contains the different column widths for the different class sizes ie xs, sm, lg etc.
         
         Set these using the for size functions like so...
         forSize(.xs, .Two)
         
         ...etc.
         */
        private (set) var columnWidthForClassSizes:[Style.DeviceSizes:ColWidth] = [.xs:.Twelve]
        
        /**
         Whether or not to anchor this specific column to the very bottom of the row.
         - important: If there are other elements that will display beneath this one and you set this to true it can cause layout issues.  You typically only want to set this on the last
         column in a row
        */
        public let anchorToBottom:Bool
                        
        open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

            let view = super.hitTest(point, with: event)
            
            if view == self {
                return nil
            }
            
            if view is UILabel || view is UIImageView {
                return nil
            }

            return view
        }
        
        open func forSize(_ sizeClass:Style.DeviceSizes, _ colWidth:ColWidth) -> Column {
            self.columnWidthForClassSizes[sizeClass] = colWidth
            return self
        }
        
        open func addRow(columns: [Column], anchorToBottom:Bool = false) -> Column {
            let card = GRBootstrapElement()
            card.addRow(columns: columns, widthInPixels: self.widthInPixels, anchorToBottom: anchorToBottom)
            return self
        }
        
        public init(cardSet: GRCardSet, xsColWidth:ColWidth, anchorToBottom:Bool = false, centeredHeight:CGFloat? = nil) {
            self.cardSet = cardSet
            self.columnWidthForClassSizes[.xs] = xsColWidth
            self.anchorToBottom = anchorToBottom
            super.init(frame: .zero)
            self.addSubview(cardSet.content)
            
            cardSet.content.snp.makeConstraints { (make) in
                // The left and the right margins are the only ones that we want to set here and that's because the columns have to have a fixed with based off of their column size
                // If we added margins to the Columns than it would in a sense increase the size of the columns and cause issues with the grid layout.
                // Look at the documentation for leftMargin and rightMargin in the Margin class for more information
                
                // The top and bottom margins will be added when the columns are added to the view because they're relative to other columns and not itself
                make.left.equalTo(self).offset((cardSet.margin.leftMargin ?? 0))
                make.right.equalTo(self).offset((cardSet.margin.rightMargin ?? 0) * -1)
                
                if let centeredHeight = centeredHeight {
                    make.height.equalTo(centeredHeight)
                    make.centerY.equalTo(self)
                } else {
                    make.top.equalTo(self)
                    make.bottom.equalTo(self)
                }
                
            }
                        
        }
        
        required public init?(coder: NSCoder) {
            self.cardSet = GRCardSet(content: UIView())
            self.widthInPixels = 0
            self.anchorToBottom = false
            super.init(coder: coder)
        }
    }
}

public typealias Column = GRBootstrapElement.Column
