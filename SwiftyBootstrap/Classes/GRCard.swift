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
    fileprivate var leftMargin:CGFloat? = 10.0
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
    fileprivate var newLine:Bool
    private var isSquare:Bool
    fileprivate var height:CGFloat?
    
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
    
    open func isNewLine (_ newLine: Bool) -> GRCardSet {
        self.newLine = newLine
        return self
    }
    
    open func getIsSquare () -> Bool {
        return self.isSquare
    }
    
    open func withName(_ name: String?) -> GRCardSet {
        self.name = name
        
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
    
    public init(color: UIColor? = .white, anchorWidthToScreenWidth:Bool = true, margin:BootstrapMargin? = nil) {
        self.anchorWidthToScreenWidth = anchorWidthToScreenWidth
        self.margin = margin ?? BootstrapMargin()
        super.init(frame: .zero)
        if let color = color {
            self.backgroundColor = color;
        } else {
            self.backgroundColor = .white
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.anchorWidthToScreenWidth = true
        self.margin = BootstrapMargin()
        super.init(coder: aDecoder)
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
        }
        
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
    open func slideDown (superview:UIView, margin: CGFloat, forTimeInterval timeInterval: TimeInterval? = nil) {
        
        if let timeInterval = timeInterval {
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
                self.slideUpAndRemove(superview: superview)
            }
        }
        
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(margin)
            make.right.equalTo(superview).offset(-margin)
            make.bottom.equalTo(superview.snp.top)
        }
        
        superview.layoutIfNeeded()
        
        self.snp.remakeConstraints { (make) in
            make.left.equalTo(superview).offset(margin)
            make.right.equalTo(superview).offset(-margin)
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
    open func slideUp (superview:UIView, margin: CGFloat) {
        
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(margin)
            make.right.equalTo(superview).offset(-margin)
            make.top.equalTo(superview.snp.bottom)
        }
        
        superview.layoutIfNeeded()
        
        self.snp.remakeConstraints { (make) in
            make.left.equalTo(superview).offset(margin)
            make.right.equalTo(superview).offset(-margin)
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
            make.left.equalTo(superview).offset(self.margin.left)
            make.right.equalTo(superview).offset(-(self.margin.right))
            make.width.equalTo(UIScreen.main.bounds.size.width - (self.margin.left) - (self.margin.right))
            
            if let viewAbove = viewAbove {
                self.topConstraint = make.top.equalTo(viewAbove.snp.bottom).offset(self.margin.top).constraint
            } else {
                self.topConstraint = make.top.equalTo(superview).offset(self.margin.top).constraint
            }
            
            if anchorToBottom {
                make.bottom.equalTo(superview).offset(-(self.margin.bottom))
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
        
//        messageCard.addElements(elements: [
//            GRCardSet(content: Style.label(withText: message, fontName: .all, size: .small, superview: nil, color: textColor ?? .white), width: .Eleven, height: nil, newLine: true, showMargins: true),
//            GRCardSet(content: Style.label(withText: "", fontName: .all, size: .small, superview: nil, color: textColor ?? .white), width: .Twelve, height: 10.0),
//            GRCardSet(content: closeButton, width: .Five, height: 44.0, newLine: true, showMargins: true)])
        
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
    
    /**
     Show a card at the bottom of the screen or top, that allows a user to take a specific action.  It's very similar to a UIAlertController but more customizable.  Make sure to add the target to the Action button.  The cancel button's default action is to simply remove the view from the screen
     
    For more information look at the ActionCard object
    
     - parameters:
        - message: The message to show the user
        - superview: The view to add this view as the subview for
        - isError: Whether or not this is being shown as the result of an error, if yes the card will be red
        - actionButtonText: The text to show on the button responsible for executing the action
        - slidUpFromButton: Whether to slide up from the bottom or the top
        - closeButtonText: The text to show for the close button.
        - customCardBackgroundColor: The color you want the background of this card to be, defaults to black
        - textColor: The color you want the card text to be, defaults to white.  This does not affect the color of the button text labels
        - showMargins: Whether you want to show margins around this card or you want it to be attached to the sides of the screen
        - shouldShow: Whether to show the card.  If no, than it will not be added to the superview
     
        - returns: An ActionCard object
     */
    open class func showActionCard (message: String, superview: UIView, isError:Bool, actionButtonText:String, slideUpFromBottom:Bool, closeButtonText:String, customCardBackgroundColor:UIColor = .black, textColor: UIColor = .white, showMargins:Bool = true, title:String? = nil, shouldShow:Bool = true) -> ActionCard {
        
        var cardBackgroundColor:UIColor!
        if isError {
            cardBackgroundColor = UIColor.Style.htRedish
        } else {
            cardBackgroundColor = customCardBackgroundColor
        }
        
        let actionCard = ActionCard(color: cardBackgroundColor)
        actionCard.anchorWidthToScreenWidth = true
        let actionButton = Style.largeButton(with: actionButtonText, superview: nil, backgroundColor: UIColor.Style.htBlueish)
        actionButton.titleLabel?.font = UIFont(name: FontNames.allBold.rawValue, size: FontSizes.small.rawValue)
        let closeButton = Style.largeButton(with: closeButtonText, superview: nil, backgroundColor: .red)
        closeButton.titleLabel?.font = UIFont(name: FontNames.allBold.rawValue, size: FontSizes.small.rawValue)
        
        actionButton.showsTouchWhenHighlighted = true
        closeButton.showsTouchWhenHighlighted = true
        
        actionButton.layer.cornerRadius = 25
        closeButton.layer.cornerRadius = 25
                        
//        actionCard.addElements(elements: [
//            GRCardSet(content: Style.label(withText: message, fontName: .all, superview: nil, color: textColor, textAlignment: .center), width: .Twelve, height: nil, newLine: true, showMargins: true).withName("label"),
//            GRCardSet(content: Style.label(withText: "", superview: nil, color: textColor), width: .Twelve, height: 10.0).withName("spacer"),
//            GRCardSet(content: actionButton, width: .Twelve, height: 50.0, newLine: true, showMargins: true),
//            GRCardSet(content: closeButton, width: .Twelve, height: 50.0, newLine: true, showMargins: true)])
        
        if let title = title {
            actionCard.addElement(element: GRCardSet(content:
                Style.label(withText: title,
                            fontName: .allBold,
                            size: .medium,
                            superview: nil,
                            color: textColor,
                            textAlignment: .center),
                     height: nil,
                     newLine: true), atIndex: 0)
        }
        
        if shouldShow {
            if slideUpFromBottom {
                actionCard.slideUp(superview: superview, margin: showMargins ? Sizes.smallMargin.rawValue : 0)
            } else {
                actionCard.slideDown(superview: superview, margin: showMargins ? Sizes.smallMargin.rawValue : 0)
            }
        }
        
        actionCard.actionButton = actionButton
        actionCard.cancelButton = closeButton
        closeButton.addTargetClosure { (_) in
            
            if slideUpFromBottom {
                actionCard.slideDownAndRemove(superview: superview)
            } else {
                actionCard.slideUpAndRemove(superview: superview)
            }
        }
                
        actionCard.layer.zPosition = 100
        
        return actionCard
    }
    
    open class ActionCard: GRBootstrapElement {
        open weak var actionButton:UIButton?
        open weak var cancelButton:UIButton?
    }
    
    open class Row: UIView {
        
        private var columns = [Column]()
        
        open var widthInPixels = UIScreen.main.bounds.size.width
        
        open var anchorWidthToScreenWidth:Bool = true
        
        open var anchorLastElementToBottom = true
        
        open var horizontalLayout = true
        
        open var bottomConstraint:Constraint?
        
        open var margin:BootstrapMargin?
        
        /**
         Add a list of elements to the Card.  This should only be called once.  If there are already elements in this Card than instead use the addElement function which will only add 1 element
         
         - parameter elements: The card sets to add to the card
         - returns: A GRCard object which can be ignored if desired
         */
        open func addColumns (columns: [Column], margin: BootstrapMargin?) {
            self.margin = margin
            
            var currentXPos:CGFloat = 0
            
            if columns.first == nil {
                return
            }
            
            if (self.columns.count == 0) {
                self.columns.append(contentsOf: columns)
            }
            
            // We know that the first element is set because the elements array has a count of more than zero
            var elementAbove = columns.first!.cardSet.content
            
            for index in 0...columns.count - 1 {
                
                // Make sure that the content hasn't accidentally been added to a view already, if so, remove the column it's a subview of
                columns[index].cardSet.content.superview?.removeFromSuperview()
                let column = columns[index]
                self.addSubview(column)
                
                // If this element is not to span across the entire screen, than we need to check to see if this element is going to go past the screen on the right side
                // and if so, set the elements newLine property to true so that it will display on a new line...
                if column.colWidth != .Twelve && self.anchorWidthToScreenWidth {
                    let width = self.getWidth(width: column.colWidth.rawValue)
                    column.widthInPixels = width
                    
                    if currentXPos + width > UIScreen.main.bounds.size.width {
                        column.cardSet.newLine = true
                        currentXPos = 0
                    }
                } else if (column.colWidth == .Twelve) {
                    column.cardSet.newLine = true
                }
                
                // If this is the first element in the card than it's new line property should be set to true
                if column.cardSet.content == columns.first?.cardSet.content {
                    column.cardSet.newLine = true
                    currentXPos = 0
                }
                
                column.snp.makeConstraints({ (make) in
                    self.setCardSetsTopConstraint(column: column, elementAbove: &elementAbove, index: index, make: make, currentXPos: &currentXPos)
                    self.setCardSetsLeftConstraint(column: column, index: index, make: make, currentXPos: &currentXPos)
                    self.setHeight(column: column, make: make)
                    self.setWidthOrRightConstraint(column: column, make: make, currentXPos: &currentXPos)
                    self.setBottomConstraint(column: column, make: make)
                })
            }
            
            return
        }
        
        private func setBottomConstraint (column:Column, make:ConstraintMaker) {
            // Set the bottom element
            if (column.cardSet.content == columns.last?.cardSet.content && self.anchorLastElementToBottom == true) {
                self.bottomConstraint = make.bottom.equalTo(self).constraint
            }
        }
        
        private func setWidthOrRightConstraint (column: Column, make:ConstraintMaker, currentXPos:inout CGFloat) {
            // WIDTH OR RIGHT CONSTRAINT
            // Set the right contraint or the width.  If the element is full screen and we want to show the margins than we set the right constraint, otherwise we set the elements width
            if (self.horizontalLayout && column.colWidth != .Twelve) {
                make.width.equalTo(column.widthInPixels)
                currentXPos += column.widthInPixels
            }
            else if (column.colWidth == .Twelve) {
                make.right.equalTo(self)
            } else {
                if column.colWidth != .Twelve {
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
        
        private func setCardSetsTopConstraint (column: Column, elementAbove:inout UIView, index: Int, make:ConstraintMaker, currentXPos:inout CGFloat) {
            if (column.cardSet.content == columns.first?.cardSet.content) {
                // Set the top of this element relative to the card's top
                make.top.equalTo(self)
            } else {
                if column.cardSet.newLine {
                    // Place this element below the previous element
                    make.top.equalTo(elementAbove.snp.bottom)
                    elementAbove = column.cardSet.content
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
            let fullSizeWidth =  self.widthInPixels - (self.margin?.left ?? 0) - (self.margin?.right ?? 0)
            let screenColSize = fullSizeWidth / 12.0
                
            return width * screenColSize;
            
        }
        
    }
    
    open class Column: UIView {
        
        open var cardSet:GRCardSet
        
        open var widthInPixels: CGFloat!
        
        open var colWidth:ColWidth
        
        open func addRow(columns: [Column], anchorToBottom:Bool = false) -> Column {
            let card = GRBootstrapElement()
            card.addRow(columns: columns, widthInPixels: self.widthInPixels, anchorToBottom: anchorToBottom)
            return self
        }
        
        public init(cardSet: GRCardSet, colWidth:ColWidth) {
            self.cardSet = cardSet
            self.colWidth = colWidth
                        
            super.init(frame: .zero)
            self.addSubview(cardSet.content)
            
            cardSet.content.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(cardSet.margin.leftMargin ?? 0)
                make.right.equalTo(self).offset((cardSet.margin.rightMargin ?? 0) * -1)
                make.top.equalTo(self).offset(cardSet.margin.topMargin ?? 0)
                make.bottom.equalTo(self).offset((cardSet.margin.bottomMargin ?? 0) * -1)
            }
        }
        
        required public init?(coder: NSCoder) {
            self.cardSet = GRCardSet(content: UIView())
            self.widthInPixels = 0
            self.colWidth = .One
            super.init(coder: coder)
        }
    }
}

public typealias Column = GRBootstrapElement.Column
