//
//  BootstrapColumn.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/22/22.
//

import Foundation
import SnapKit

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
    public init(_ cardSet: GRCardSet, xsColSpan: ColSpan, anchorToBottom: Bool = false, centeredHeight: CGFloat? = nil, centeredWidth: CGFloat? = nil) {
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
