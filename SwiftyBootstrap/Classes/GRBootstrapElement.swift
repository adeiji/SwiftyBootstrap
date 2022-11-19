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


/*:

They can be stacked horizontally or verticall. A GRCard differs from a Stack View in that a Stack View is used to split a view into equal sizes whereas a GRCard can have elements of all sizes organized within it.
 
 How to use the card

 let card = GRCard(color: .white)
 card.addElements(elements: [cardSet1, cardSet2])
 card.addToSuperview(superview: self.view, margin: Sizes.smallMargin.rawValue, viewAbove:nil, anchorToBottom:false)
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

    open var rows: [Row] = [Row]()

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

            self.topConstraint = make.top.equalTo(superview).offset((Sizes.smallMargin.rawValue * 3.0) + margin).constraint
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
                self.topConstraint = make.top.equalTo(superview).offset(topMargin).constraint
            }

            if anchorToBottom {
                let bottomMargin = BootstrapMargin.getMarginInPixels(self.margin.bottom)
                self.snapkitMargins?.bottom = make.bottom.equalTo(superview).offset(-(bottomMargin)).constraint
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

    @discardableResult
    private func getOrRemoveItemWithName(_ name: String, elements: [GRCardSet], superCardElements: [GRCardSet]? = nil, cardToRemoveElementFrom: GRBootstrapElement? = nil, shouldRemoveCard: Bool = false) -> GRCardSet? {

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
    
    /// A row is similar to a row in Twitter Bootstrap.
    ///
    /// A row consists of a list of columns and can expand according to the size of the children columns. A row is used solely for layout of UI elements.
    open class Row: UIView {
        
        /// The list of columns in this row.
        private var columns = [Column]()

        /// The width of this row in pixels
        open var widthInPixels = GRCurrentDevice.getCorrectWidth() {
            didSet {
                if self.widthRatio == nil {
                    // We need to get the correct ratio of this row's width in comparison to the width of the device in order to make sure that when
                    // the user rotates the device we still keep the same ratio for this row.  For example:
                    // If this row's width is 500 and the Device width is 1000, that means that the row's width is 1/2 of the screen width
                    // When the user rotates, we want the row to still be 1/2 of the new screen width.
                    // So if the new screen width is 2000, the row width should be 1000
                    self.widthRatio = self.widthInPixels / GRCurrentDevice.getCorrectWidth()
                }

            }
        }
        
        /// Whether or not to anchor the width of this row to the width of it's superview. If this is not set to true then make sure that you have some way of specifying what the width of the superview is otherwise you'll have AutoLayout issues
        open var anchorWidthToSuperviewWidth: Bool = true
        
        /// Whether or not to anchor the last element (column) to the bottom of this row.
        ///
        /// If this is set to false, then make sure that you have satisfied the height constraint requirements for this row by some other means.
        open var anchorLastElementToBottom = true
        
        /// Whether or not the UI elements are being laid out horizontally or vertically
        open var horizontalLayout = true
        
        /// The constraint which fixes the bottom of the row to it's superview
        open var bottomConstraint: Constraint?
        
        /// The margins for this row
        open var margin: BootstrapMargin?
        
        /// The ratio of the width of this row to the width of it's superview
        ///
        /// If a row has a width of 300 and it's superview has a row of 600 then the ratio is 0.5. This is important because if the width of the superview changes, say because the device went from portrait to landscape, then the ratio still needs to stay the same. So if the width is now 1400 the width of the row needs to be 700. (if you want to keep the same ratio that is)
        private var widthRatio: CGFloat!

        
        /// Get the ration of the width of the row to the width of it's superview
        /// - Returns: The width ratio of the row to superview
        open func getWidthRatio() -> CGFloat {
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
        open func addColumns(columns: [Column], margin: BootstrapMargin?) {

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
            var currentXPos: CGFloat = 0

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

        
        /// Redraw the row and it's children on the screen. (Called each time layout subviews is called)
        public func redraw() {
            guard var columnAbove = columns.first else {
                return
            }
            var currentXPos: CGFloat = 0

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
                    if (self.anchorWidthToSuperviewWidth == true) {
                        column.cardSet.newLine = true
                    }
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
        private func getCorrectSizeClass(column: Column) -> ColSpan {
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

        
        /// Adds the AutoLayout constraints for a column
        /// - Parameters:
        ///   - column: The column to add the AutoLayout constraints for
        ///   - index: The index of the column in relation to the array it's a part of
        ///   - columnAbove: The column that is positioned above this column
        ///   - currentXPos: The current x-position. As we add columns this value is updated so that we position the next column at the correct x-position
        private func addColumnConstraints(column: Column, index: Int, columnAbove: inout Column, currentXPos: inout CGFloat) {

            let colSpan = self.getCorrectSizeClass(column: column)

            let width = self.getWidth(width: colSpan.rawValue)
            column.widthInPixels = width

            // If this element is not to span across the entire screen, than we need to check to see if this element is going to go past the screen on the right side
            // and if so, set the elements newLine property to true so that it will display on a new line...
            if colSpan != .Twelve {
                if currentXPos + width > self.widthInPixels {
                    if (self.anchorWidthToSuperviewWidth) {
                        column.cardSet.newLine = true
                    }

                    currentXPos = 0
                }
            } else if (colSpan == .Twelve) {
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
                self.setWidthOrRightConstraint(column: column, make: make, colSpan: colSpan, currentXPos: &currentXPos)
                self.setBottomConstraint(column: column, make: make)
            })
        }

        private func setBottomConstraint(column: Column, make: ConstraintMaker) {

            if (self.anchorWidthToSuperviewWidth == false) {
                self.bottomConstraint = make.bottom.equalTo(self).offset((column.cardSet.margin.bottomMargin ?? 0) * -1).constraint
            } else if ((column.cardSet.content == columns.last?.cardSet.content && self.anchorLastElementToBottom == true) || column.anchorToBottom == true) {
                self.bottomConstraint = make.bottom.equalTo(self).offset((column.cardSet.margin.bottomMargin ?? 0) * -1).constraint
            }
        }

        private func setWidthOrRightConstraint(column: Column, make: ConstraintMaker, colSpan: ColSpan, currentXPos: inout CGFloat) {
            // WIDTH OR RIGHT CONSTRAINT
            // Set the right contraint or the width.  If the element is full screen and we want to show the margins than we set the right constraint, otherwise we set the elements width

            if (self.horizontalLayout && colSpan != .Twelve) {
                make.width.equalTo(column.widthInPixels)
                currentXPos += column.widthInPixels

                if (anchorWidthToSuperviewWidth == false && column == self.columns.last) {
                    make.right.equalTo(self)
                    return
                }
            } else if (colSpan == .Twelve) {
                make.right.equalTo(self)
            } else {
                if colSpan != .Twelve {
                    make.width.equalTo(column.widthInPixels)
                    currentXPos += column.widthInPixels
                } else {
                    make.width.equalTo(self)
                    currentXPos = 0
                }
            }
        }

        private func setHeight(column: Column, make: ConstraintMaker) {
            // If element is a text field than give it a specific height
            if (column.cardSet.content.isKind(of: UITextField.self)) {
                make.height.equalTo(column.cardSet.height ?? 50)
            } else if column.cardSet.getIsSquare() {
                make.height.equalTo(column.cardSet.content.snp.width)
            } else if let height = column.cardSet.height {
                make.height.equalTo(height)
            }
        }

        private func setCardSetsTopConstraint(column: Column, columnAbove: inout Column, index: Int, make: ConstraintMaker, currentXPos: inout CGFloat) {

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

        private func setCardSetsLeftConstraint(column: Column, index: Int, make: ConstraintMaker, currentXPos: inout CGFloat) {
            if (column.cardSet.newLine || index == 0) {
                // Set the left margins relative to the card
                make.left.equalTo(self)
            } else {
                make.left.equalTo(columns[index - 1].snp.right)
            }
        }

        open func getWidth(width: CGFloat) -> CGFloat {
            let fullSizeWidth = self.widthInPixels
            let screenColSize = fullSizeWidth / 12.0

            return width * screenColSize;

        }

    }

    
    /**
     A column is used as a layout tool.
    
     It works very similar to a bootstrap column. A column is not an object that can exist on it's own, it has to be added to a Row.  It is used to store any type of UI Element and display it across a specific column span.
              
     ```
     card.addRow(columns: [
        Column(cardSet: Style.largeButton(with: "Okay").toCardSet(), xsColSpan: .Twelve).forSize(.md, .Six),
        Column(cardSet: Style.largeButton(with: "Cancel").toCardSet(), xsColSpan: .Twelve).forSize(.md, .Six)],
            anchorToBottom: true
     )
     ```
    */
    open class Column: UIView {

        open var cardSet: GRCardSet

        open var widthInPixels: CGFloat!
        /**
         This contains the different column widths for the different class sizes ie xs, sm, lg etc.

         Set these using the for size function like so...
         .forSize(.xs, .Two).forSize(.md, .One)

         ...etc.
         */
        private (set) var columnWidthForClassSizes: [DeviceSizes: ColSpan] = [.xs: .Twelve]

        /**
         Whether or not to anchor this specific column to the very bottom of the row.
         - important: If there are other elements that will display beneath this one and you set this to true it can cause layout issues.  You typically only want to set this on the last
         column in a row
         */
        public let anchorToBottom: Bool

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

        
        /// The column span of the column for a specific device size
        ///
        /// Device sizes are categorized by sizes of either .xs (xtra small) to .xl (xtra large)
        /// - Parameters:
        ///   - sizeClass: The size class that this column should have a column span for. For example, .xs (xtra small)
        ///   - colSpan: How many columns this column should span. If you span 6 columns that's half of it's superview because each view has a span of 12 columns
        /// - Returns: This column (self)
        open func forSize(_ sizeClass: DeviceSizes, _ colSpan: ColSpan) -> Column {
            self.columnWidthForClassSizes[sizeClass] = colSpan
            return self
        }

        
        /// Add a row to this column
        /// - Parameters:
        ///   - columns: The columns to add as children for this row
        ///   - anchorToBottom: Whether or not to anchor this row to the bottom of its superview
        /// - Returns: This column (self)
        open func addRow(columns: [Column], anchorToBottom: Bool = false) -> Column {
            let card = GRBootstrapElement()
            card.addRow(columns: columns, widthInPixels: self.widthInPixels, anchorToBottom: anchorToBottom)
            return self
        }

        
        /// Creates a new instance of a column
        ///
        /// - Parameters:
        ///   - cardSet: The card set that is contained within this column
        ///   - xsColSpan: The number of layout columns that this column should span on an extra small screen (iPhone). If no other size class columm span is specified then this is the size that's used for all device sizes
        ///   - anchorToBottom: Whether or not to anchor this column's bottom to the row bottom.
        ///   - centeredHeight: Whether or not the UI element that is within this column should have a fixed height and not have the height be relative to the height of the column itself. If this value is set the height of the UI element will be fixed but it will be centered in the column
        ///   - centeredWidth: Whether or not he UI element that is within this column should have a fixed width and not have the width be relative to the width of the column itself. If this value is set the width of the UI element will be fixed and centered in the column
        /// - TODO: In the future we need to automatically anchor the last column to a row. However for right now we don't do this because a person may not want this functionality.
        public init(cardSet: GRCardSet, xsColSpan: ColSpan, anchorToBottom: Bool = false, centeredHeight: CGFloat? = nil, centeredWidth: CGFloat? = nil) {
            self.cardSet = cardSet
            self.columnWidthForClassSizes[.xs] = xsColSpan
            self.anchorToBottom = anchorToBottom
            super.init(frame: .zero)
            self.addSubview(cardSet.content)

            cardSet.content.snp.makeConstraints { (make) in
                // The left and the right margins are the only ones that we want to set here and that's because the columns have to have a fixed with based off of their column size
                // If we added margins to the Columns than it would in a sense increase the size of the columns and cause issues with the grid layout.
                // Look at the documentation for leftMargin and rightMargin in the Margin class for more information

                if let centeredWidth = centeredWidth {
                    make.width.equalTo(centeredWidth)
                    make.centerX.equalTo(self)
                } else {
                    // The top and bottom margins will be added when the columns are added to the view because they're relative to other columns and not itself
                    make.left.equalTo(self).offset((cardSet.margin.leftMargin ?? 0))
                    make.right.equalTo(self).offset((cardSet.margin.rightMargin ?? 0) * -1)
                }

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
