//
//  GRNavBar.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 9/30/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

class GRNavBar:UIView {
    @IBOutlet weak var leftButton:UIButton? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let leftButton = self.leftButton, let header = self.header else { return }
            self.addSubview(leftButton)
            leftButton.snp.makeConstraints({ (make) in
                make.left.equalTo(self)
                make.centerY.equalTo(header)
                make.width.equalTo(45)
                make.height.equalTo(50)
            })
        }
    }
    @IBOutlet weak var rightButton:UIButton? {
        didSet {
            if let rightButton = self.rightButton, let header = self.header {
                self.addSubview(rightButton)
                rightButton.snp.makeConstraints { (make) in
                    make.right.equalTo(self).offset(-10)
                    make.width.equalTo(50)
                    make.height.equalTo(50)
                    make.centerY.equalTo(header)
                }
            }
        }
    }
    
    weak var thirdRightButton:UIButton?
    
    @IBOutlet weak var secondRightButton:UIButton?
    
    @IBOutlet weak var secondLeftButton:UIButton?
    weak var subheading:UILabel?
    weak var header:UILabel?
    weak var backButton:UIButton? {
        didSet {
            if let backButton = self.backButton, let header = self.header {
                self.addSubview(backButton)
                backButton.snp.remakeConstraints { (make) in
                    make.left.equalTo(self)
                    make.centerY.equalTo(header)
                    make.width.equalTo(50)
                    make.height.equalTo(50)
                }
            }
            
        }
    }
    /// The height of this nav bar
    var height:Int? {
        didSet {
            guard
                let superview = self.superview,
                let height = self.height
                else {
                    return
            }
            self.snp.remakeConstraints { (make) in
                make.left.equalTo(superview)
                make.right.equalTo(superview)
                make.top.equalTo(superview).offset(Style.isIPhoneX() ? 0 : 20)
                make.height.equalTo(Style.isIPhoneX() ? height + 20 : height)
            }                        
        }
    }
    
    /// The offset of the header top from the centerY of the navbar
    var headerOffset:Int? {
        didSet {
            guard let offset = self.headerOffset else { return }
            guard let superview = self.superview else { return }
            
            self.header?.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self)
                if Style.isIPhoneX() {
                    make.centerY.equalTo(self).offset(offset + 20)
                } else {
                    make.centerY.equalTo(self).offset(offset)
                }
                
                make.left.equalTo(superview).offset(40)
                make.right.equalTo(superview).offset(-40)
            })
        }
    }
}
