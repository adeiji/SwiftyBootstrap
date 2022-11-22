//
//  GRBootstrapElement.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 8/10/22.
//

import Foundation
import SnapKit

fileprivate struct SnapkitMargins {
    /// The left margin for this card
    var left: Constraint?

    /// The right margin for this card
    var right: Constraint?

    /// The top margin for this card
    var top: Constraint?

    /// The bottom margin for this card
    var bottom: Constraint?

    /// The margin constants will be reset based off of the current screen size
    func recalculateMarginUsingBootstrapMargin(_ bootstrapMargin: BootstrapMargin) {
        self.left?.update(offset: BootstrapMargin.getMarginInPixels(bootstrapMargin.left))
        self.right?.update(offset: -BootstrapMargin.getMarginInPixels(bootstrapMargin.right))
        self.top?.update(offset: BootstrapMargin.getMarginInPixels(bootstrapMargin.top))
        self.bottom?.update(offset: -BootstrapMargin.getMarginInPixels(bootstrapMargin.bottom))
    }
}


/**
 This class allows a user to layout an object similar to how Twitter Bootstrap works, with it's elements spread across columns and rows.
 
 Each bootstrap element must contain at least one row.  You can then add UI elements inside of columns to create a responsive UI.
 
 Below is an example:

 ```
 card.addRow(columns: [
     Column(UILabel().withAttributes(closure: { view in
         let label = view as? UILabel
         label?.text = "This is just an example."
     })
     .cardSet(),
         /* When the screen is very
          small like an iPhone in
          portrait or on the side of the screen in
          split screen mode then
          span the full width of
          the screen */
         xsColSpan: .Twelve)
         /** When the screen is
          smaller like an iPhone
          in landscape mode or half
          of the screen in split
          screen mode then span
          half the width of the
          screen */
         .forSize(.sm, .Six)
         /** When the screen is
          medium size like an
          iPad in portrait mode
          then the width of this
          label will be 1/4 the
          width of the screen */
         .forSize(.md, .Three)
 ], anchorToBottom: true)
 
 card.addToSuperview(superview: self.view)
 ```
*/
open class GRBootstrapElement: UIView {

    /// The top constraint of the card.
    open weak var topConstraint: Constraint?

    open weak var viewAbove: UIView?

    /// Whether or not this card should be anchored to the bottom of it's superview
    open var anchorToBottom: Bool?
    /// The elements that are shown on this card.
    internal var elements: [GRCardSet] = [GRCardSet]()

    /// Whether or line up the contents of this card horizontally
    open var horizontalLayout: Bool = false

    /// Whether to set the maximum width of this card to the width of the superview.  If this is set to **true** then cards that will go beyond the width of the superview will automatically be pushed to the next line.
    open var anchorWidthToSuperviewWidth: Bool

    /**
     Whether or not to anchor the last element in the elements array to the bottom of the card.

     An instance where you would not want this is if you have a card inside of a scroll view with a fixed height.  Since the height is fixed you wouldn't need to worry about anchoring the last element to the bottom because that's usually done if you need a view to expand vertically based on it's subviews.  Typically this should be set to true.

     If you find that you have a scroll view with this card as the subview, and the card's horizontalLayout is set to true, and the last element's height is different than what you were expecting, it's probably because this value was set to true.
     */
    open var anchorLastElementToBottom: Bool = true

    internal var rows: [Row] = [Row]()

    /// The margin of the card when it's added to the superview
    public let margin: BootstrapMargin

    /// This is the view that this view will be a subview of. Set this value if you want this object to have it's width based off the width of the superview.  This is not needed if the width of this card/element is the width of the screen
    private let customSuperview: UIView?

    private var touchPoint: CGPoint?

    /// Store the margin snapkit constraints for this bootstrap element.  We store this value so that we can update it later in case there is a screen size change
    private var snapkitMargins: SnapkitMargins?


    /// Initialize a new GRBootstrapElement object
    /// - Parameters:
    ///   - color: The color that you want the background of this element to be. It defaults to white
    ///   - anchorWidthToSuperviewWidth: Whether or not to set the width of this element to the width of the screen. If you set this value to no, then as you add columns to this card they won't automically go to the next line when the width of all the columns goes beyond the width of the screen.
    ///   - margin: The margin outside of this element
    ///   - superview: The view to add this view to
    public init(color: UIColor? = .white, anchorWidthToSuperviewWidth: Bool = true, margin: BootstrapMargin? = nil, superview: UIView? = nil) {
        self.anchorWidthToSuperviewWidth = anchorWidthToSuperviewWidth
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

        // Get the size of the device, for example is it, .xs, .sm, .md
        GRCurrentDevice.shared.size = GRCurrentDevice.getScreenSize()

        // We need to make sure that our layout still displays on the screen with all the proper specifications so we make sure that when this method is called we redo all the constraints. This is important basically for when the user has changed the orientation from portrait to landscape and vice versa
        self.redoConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.anchorWidthToSuperviewWidth = true
        self.margin = BootstrapMargin()
        self.customSuperview = nil
        super.init(coder: aDecoder)
    }

    /**
     Redo all the constraints for this element and all it's rows and each row's column's constraints.

     This should typically be called when the orientation of the device changes.
     */
    private func redoConstraints() {
        self.snapkitMargins?.recalculateMarginUsingBootstrapMargin(self.margin)
        self.rows.forEach { [weak self] (row) in
            guard let self = self else {
                return
            }
            row.widthInPixels = self.customSuperview?.bounds.width ?? (GRCurrentDevice.getCorrectWidth() * row.getWidthRatio())
            row.redraw()
        }
    }

    /**
     The reason why we're overriding this function is because we need to make sure that we only get the view that we want when the user touches the screen.
     
     Because of the way that this class is configured, there's many layers of UI elements, so we want to bypass the UI elements that don't need to be interacted with and only return the element that actually want to interact with when touched
     */
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


    /**
     
     Add a row to the element. Rows are similar to Bootstrap rows. They obviously always start on a new line and they consist of columns with various attributes which define how they display on the
        
     Here's an example of how to use this method
     ```
     card.addRow(columns: [
        Column(cardSet: Style.largeButton(with: "Okay").toCardSet(), xsColSpan: .Twelve).forSize(.md, .Six),
        Column(cardSet: Style.largeButton(with: "Cancel").toCardSet(), xsColSpan: .Twelve).forSize(.md, .Six)],
            anchorToBottom: true
     )
     ```
     
    - Parameters:
        - columns: The columns to add to this row
        - widthInPixels: If you want this row to have a fixed width then set this parameter to a value other then nil, if you want the row to expand the full width of it's superview, then don't set this value. Defaults to nil
        - myAnchorToBottom: Whether or not to anchor this row to the bottom of it's superview. Make sure that you set this value to true if your adding the last row and you want the row to constrain to the bottom of it's superview. If you don't set this, make sure that you add a bottom constraint manually, otherwise you can run into AutoLayout issues
        
     - Returns: Self, with the rows and columns added
     */
    @discardableResult open func addRow(columns: [Column], widthInPixels: CGFloat? = nil, anchorToBottom myAnchorToBottom: Bool = false) -> GRBootstrapElement {
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
        row.anchorWidthToSuperviewWidth = self.anchorWidthToSuperviewWidth
        row.addColumns(columns: columns, margin: self.margin)
        self.rows.append(row)

        return self
    }

    /// This is the constraint that attaches the last element to the bottom of the Card. It's an open parameter because you can set this constraint yourself if you manually set bottom constraint and don't use the anchorToBottom parameter of the addRow method
    open var bottomConstraint: Constraint?


    /// Slide this element down and then remove it from it's superview
    /// - Parameter superview: The superview of this element
    open func slideDownAndRemove(superview: UIView) {

        if let topConstraint = self.topConstraint {
            topConstraint.update(offset: 5000)
        }

        UIView.animate(withDuration: 1.0, animations: {
            superview.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    // TODO: I can't remember why I have the user send the superview manually. I need to test and see if we can just use the .superview method to retrieve the superview, making things easier and cleaner.
    /// Slide this element up and then remove it from it's superview
    /// - Parameter superview: The superview for this element.
    open func slideUpAndRemove(superview: UIView) {

        if let topConstraint = self.topConstraint {
            topConstraint.update(offset: -5000)
        }

        UIView.animate(withDuration: 1.0, animations: {
            superview.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }


    /// Slides the card down and then adds it to the superview. This method is more so used when you trying to display something like a card. For example, if you want to display a quick message to the user, then you would most likely use this method. See GRMessageCard
    ///
    /// - Parameters:
    ///   - superview: The view to add this bootstrap element to
    ///   - margin: The margin that you want to show outside of this element
    ///   - width: The width of this element. This value should be set to nil if you want the width of the element to be relative to the width of the superview
    ///   - timeInterval: The amount of time it should take for this element to slide onto the screen
    open func slideDown(superview: UIView, margin: CGFloat, width: CGFloat? = nil, forTimeInterval timeInterval: TimeInterval? = nil) {

        if let timeInterval = timeInterval {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
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

            self.topConstraint = make.top.equalTo(superview.safeAreaLayoutGuide).offset((10 * 3.0) + margin).constraint
        }

        UIView.animate(withDuration: 0.2) {
            superview.layoutIfNeeded()
        }
    }

    /// See slideDown method of this class
    open func slideUp(superview: UIView, margin: CGFloat = 0, width: CGFloat? = nil, timeInterval: TimeInterval? = nil) {

        if let timeInterval = timeInterval {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
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
            self.topConstraint = make.bottom.equalTo(superview.safeAreaLayoutGuide).offset(-margin).constraint
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
    ///   - anchorToBottom: Whether the card should be anchored to the bottom of the view. Remember that you need to satisfy AutoLayout constraint requirements, so if this is supposed to be the last bottom element in a superview, either you need to see this to true, or you need to make sure that you have an element that is anchored to the bottom of the superview that will satisfy AutoLayout constraints
    open func addToSuperview(superview: UIView, viewAbove: UIView? = nil, anchorToBottom: Bool = false) {
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in

            self.snapkitMargins = SnapkitMargins()

            let leftMargin = BootstrapMargin.getMarginInPixels(self.margin.left)
            let rightMargin = BootstrapMargin.getMarginInPixels(self.margin.right)

            self.snapkitMargins?.left = make.left.equalTo(superview).offset(leftMargin).constraint
            self.snapkitMargins?.right = make.right.equalTo(superview).offset(-(rightMargin)).constraint

            if let viewAbove = viewAbove {
                self.topConstraint = make.top.equalTo(viewAbove.snp.bottom).offset(BootstrapMargin.getMarginInPixels(self.margin.top)).constraint
                self.snapkitMargins?.top = self.topConstraint
            } else {
                let topMargin = BootstrapMargin.getMarginInPixels(self.margin.top)
                self.topConstraint = make.top.equalTo(superview.safeAreaLayoutGuide).offset(topMargin).constraint
            }

            if anchorToBottom {
                let bottomMargin = BootstrapMargin.getMarginInPixels(self.margin.bottom)
                self.snapkitMargins?.bottom = make.bottom.equalTo(superview.safeAreaLayoutGuide).offset(-(bottomMargin)).constraint
            }
        }

        self.viewAbove = viewAbove
        self.anchorToBottom = anchorToBottom

    }

    /**
        Redraw all the elements onto the screen. This method is called every time LayoutSubviews is called
     */
    internal func redraw() {
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


    /// Remove all the UI elements of this Bootstrap Element from the screen and remove the reference to those UI elements from this class
    open func removeElements() {
        self.elements.forEach { (element) in
            element.content.removeFromSuperview()
        }

        self.elements = []
    }


    /// Get a child cardset of this bootstrap element section
    /// - Parameters:
    ///   - name: The name of the child cardset
    ///   - superCardElements: The set of cards that would contain this element.
    /// - Returns: The card set with the given name
    open func getElementNamed(_ name: String, superCardElements: [GRCardSet]? = nil) -> GRCardSet? {
        return self.getOrRemoveItemWithName(name, elements: self.elements, superCardElements: superCardElements)
    }

    /// Gets a card set with given name and either only returns it or removes it.
    ///
    /// - Important:
    /// When you created the card set, you need to have given the card set a name so that you can retrieve it whenever you need to.
    /// - Parameters:
    ///   - name: The name of the card set you want to get or remove
    ///   - elements: The card sets in which to search through
    ///   - superCardElements: The parents of any of the card sets (this is a recursive function, so this parameter is set only when the function needs to check the superviews for the name of this element)
    ///   - cardToRemoveElementFrom: The bootstrap element to remove this element from
    ///   - shouldRemoveCard: Whether or not to remove the card or just return it
    /// - Returns: The card with the given name
    @discardableResult private func getOrRemoveItemWithName(_ name: String, elements: [GRCardSet], superCardElements: [GRCardSet]? = nil, cardToRemoveElementFrom: GRBootstrapElement? = nil, shouldRemoveCard: Bool = false) -> GRCardSet? {

        var myElements = elements
        if myElements.count > 0 {

            let element = myElements.removeFirst()

            if element.name == name {
                if shouldRemoveCard {
                    element.content.removeFromSuperview()
                    cardToRemoveElementFrom?.elements.removeAll {
                        $0.name == element.name
                    }
                    cardToRemoveElementFrom?.redraw()
                }

                return element
            } else {
                // If we've reached the last element, than check to see if this current element has a parent card, and if so then search it's elements
                if myElements.count == 0 {
                    if
                            let superCard = element.content.superview?.superview as? GRBootstrapElement,
                            let superCardElements = superCardElements {
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

    
    /// Remove an element of a given name
    /// - Parameter name: The name the developer gave the element that needs to now be removed
    open func removeElementNamed(_ name: String) {
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
    open func addElement(element: GRCardSet, atIndex: Int? = nil) {
        if let bottomConstraint = self.bottomConstraint {
            bottomConstraint.deactivate()
        }

        if let index = atIndex {
            self.elements.insert(element, at: index)
        } else {
            self.elements.append(element);
        }
    }
}
