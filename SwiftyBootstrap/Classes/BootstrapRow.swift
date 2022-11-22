//
//  BootstrapRow.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/22/22.
//

import Foundation
import SnapKit

/// A row is similar to a row in Twitter Bootstrap.
///
/// A row consists of a list of columns and can expand according to the size of the children columns. A row is used solely for layout of UI elements.
internal class Row: UIView {
    
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

    
    /// Set the constraint for a columns width or for the constraint relative to an item on it's right
    /// - Parameters:
    ///   - column: The column to add constraints for
    ///   - make: The object which allows us to make constraints
    ///   - colSpan: How many columns this column should span across
    ///   - currentXPos: The current x position that we're at when placing colums on the screen
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

    
    /// Set the height of a column
    /// - Parameters:
    ///   - column: The column to set the height for
    ///   - make: The object that allows us to make constraints
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

    
    /// Set the top constraint for a column
    /// - Parameters:
    ///   - column: The column to set the top constraint for
    ///   - columnAbove: The column above the first column
    ///   - index: What index in the array is this column
    ///   - make: The object that allows us to make constraints
    ///   - currentXPos: The current x position that we're at in placing the columns
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

    /// Set the left constraint for a column
    /// - Parameters:
    ///   - column: The column to set the left constraint for
    ///   - index: What index in the array is this column
    ///   - make: The object that allows us to make constraints
    ///   - currentXPos: The current x position that we're at in placing the columns
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
