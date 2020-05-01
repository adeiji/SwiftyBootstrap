//
//  GRSimpleEntryView.swift
//  Graffiti
//
//  Created by adeiji on 4/24/18.
//  Copyright © 2018 Dephyned. All rights reserved.
//

import UIKit

open class GRSimpleEntryView: UIView {
    var textFields = [UITextField]()
    var navBar:GRNavBar?
    
    func setup (superview: UIView, numberOfTextFields:Int, header:String, placeholders:[String]? = nil, labelsText:[String]) {
        superview.addSubview(self)
        self.backgroundColor = .white
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(superview)
        }
        
        let saveButton = Style.clearButton(with: "Save", superview: nil, fontSize: .small, color: UIColor.Style.darkBlueGrey)
        self.navBar = Style.navBar(withHeader: header, superview: self, leftButton: GRButton(type: .Back), rightButton: saveButton, isBackButton: true)
        var labels = [UILabel]()
        for counter in 0 ..< numberOfTextFields {
            let textField = Style.wideTextField(withPlaceholder: "", superview: nil, color: UIColor.Style.darkBlueGrey)            
            if let placeholders = placeholders {
                textField.placeholder = placeholders[counter]
            }
            
            self.textFields.append(textField)
            
            let label = Style.label(withText: labelsText[counter], fontName: .all, size: .small, superview: nil, color: UIColor.Style.darkBlueGrey)
            labels.append(label)
        }
        
        let labelStack = Style.viewStack(withSuperview: self, align: .left, views: labels, eachViewHeight: 45)
        labelStack.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(Sizes.smallMargin.rawValue)
            make.top.equalTo(navBar?.snp.bottom ?? self).offset(Sizes.smallMargin.rawValue)
            make.width.equalTo(80)
        }
        
        let stack = Style.viewStack(withSuperview: self, align: .left, views: self.textFields, eachViewHeight: 45)
        stack.snp.makeConstraints { (make) in
            make.left.equalTo(labelStack.snp.right)
            make.top.equalTo(labelStack)
            make.right.equalTo(self).offset(-Sizes.smallMargin.rawValue)
        }
    }
}
