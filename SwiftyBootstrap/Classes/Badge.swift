//
//  Banner.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 9/30/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

open class Badge: UIView {
    
    private weak var badgeLabel:UILabel?
    
    open var badge:String?
    
    open var textColor:UIColor?
    
    open func setup(badge:String?, textColor:UIColor = .white, backgroundColor:UIColor = .red) {
        self.badge = badge
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        
        let label = Style.label(withText: badge ?? "", size: .small, superview: self, color: textColor)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }        
    }
}

open class FocusIndicator: UIView {
    
    open func setup () {
        self.backgroundColor = UIColor.green.withAlphaComponent(0.5)
    }
}
