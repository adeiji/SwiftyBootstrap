//
//  ButtonRow.swift
//  Pods
//
//  Created by Adebayo Ijidakinro on 5/4/20.
//

import Foundation
import UIKit
import SnapKit
import SwiftyBootstrap

enum ButtonRowType {
    case Instagram
    case EqualWidths
}


open class ButtonRow: UIView {
    
    open var buttons = [UIButton]()
    open weak var rightButton:UIButton?
    open var kMargin = 5
    var type:ButtonRowType = .Instagram
    public let numberOfButtons:Int
    
    /// Stores all the buttons with the key being their title, this way we can retrieve them at will
    open var buttonStorage:[String:UIButton] = [String:UIButton]()
    
    public init(numberOfButtons: Int) {
        self.numberOfButtons = numberOfButtons
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        self.numberOfButtons = 3
        super.init(coder: coder)
    }
    
    open func addButton (button: UIButton, key:String? = nil, height: CGFloat? = nil) {
        self.addSubview(button)
        if type == .Instagram {
            button.snp.makeConstraints { (make) in
                if buttons.count > 0 {
                    make.left.equalTo((buttons.last?.snp.right)!)
                } else {
                    make.left.equalTo(self)
                }
                
                make.top.equalTo(self)
                make.width.equalTo(Sizes.smallButton.rawValue)
                make.height.equalTo(height ?? Sizes.smallButton.rawValue)
            }
        }
        self.buttons.append(button)
        
        // If the user has set a key for this button, then store it in the dictionary
        if let key = key {
            self.buttonStorage[key] = button
        }
        
        if type == .EqualWidths {
            var counter = 0
            var previousButton:UIButton!
            for button in self.buttons {
                button.snp.remakeConstraints({ (make) in
                    if button == buttons.first {
                        make.left.equalTo(self)
                    } else {
                        make.left.equalTo(previousButton.snp.right)
                    }
                    
                    let width = UIScreen.main.bounds.width / CGFloat(integerLiteral: self.numberOfButtons)
                    make.width.equalTo(width)
                    
                    if button == buttons.last {
                        make.right.equalTo(self)
                    } else {
                        make.right.equalTo(self.buttons[counter + 1].snp.left)
                    }
                    
                    make.top.equalTo(self)
                    make.bottom.equalTo(self)
                })
                
                previousButton = button
                counter = counter + 1
            }
        }
        
        button.layoutIfNeeded()
        button.alignImageAndTitleVertically()
    }
    
    open func addRightButton (button: UIButton) {
        self.addSubview(button)
        self.rightButton = button
        button.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self)
            make.width.equalTo(Sizes.smallButton.rawValue)
            make.height.equalTo(Sizes.smallButton.rawValue)
        }
    }
}

