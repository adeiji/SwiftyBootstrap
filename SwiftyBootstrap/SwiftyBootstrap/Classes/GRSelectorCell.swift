//
//  GRSelectorCell.swift
//  GraffitiAdmin
//
//  Created by Adebayo Ijidakinro on 12/11/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

/// A selector cell is simply a cell which contains a label and a button that you can click to select the cell
open class GRSelectorCell: UITableViewCell {
    
    private weak var selector: UIButton?
    
    private weak var label: UILabel?
    
    // Whether this cell is selected or not
    open var isUserSelected:Bool = false {
        didSet {
            self.redrawSelector()
        }
    }
    
    /**
     Add all the children UI elements to the cell.  You must call this method everytime you use this cell.
     
     - parameter labelText: The text to show on the main label for the cell
     - parameter showSelector: Whether to show the selector for this cell
     */
    open func setup (labelText: String, showSelector: Bool) {
        let selector = self.addSelector(showSelector: showSelector)
        self.addLabel(text: labelText, selector: selector)
        
        self.selector = selector
        self.selectionStyle = .none
    }
    
    /// Redraw the selector so that we can display whether or not its in the selected state
    private func redrawSelector () {
        if self.isUserSelected {
            self.selector?.backgroundColor = UIColor.Style.darkBlueGrey
        } else {
            self.selector?.backgroundColor = .white
        }
    }

    /**
     Add the selector.  The selector is simply a button that you can click that will change color when selected
     */
    private func addSelector (showSelector: Bool) -> UIButton {
        
        let selector = UIButton()
        selector.layer.borderWidth = 2.0
        selector.layer.borderColor = UIColor.Style.darkBlueGrey.cgColor
        
        self.contentView.addSubview(selector)
        
        selector.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(Sizes.smallMargin.rawValue)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        selector.layer.cornerRadius = 12.5
        selector.isHidden = !showSelector
        
        return selector
    }

    private func addLabel (text: String, selector: UIButton) {
        
        let label = UILabel()
        label.text = text
        label.font = FontBook.all.of(size: .small)
        label.numberOfLines = 0
        
        self.contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(selector.snp.right).offset(Sizes.smallMargin.rawValue)
            make.right.equalTo(self.contentView).offset(-Sizes.smallMargin.rawValue)
            make.top.equalTo(self.contentView).offset(Sizes.smallMargin.rawValue)
            make.bottom.equalTo(self.contentView).offset(-Sizes.smallMargin.rawValue)
        }

    }
    
}

