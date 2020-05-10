//
//  ButtonRow.swift
//  Pods
//
//  Created by Adebayo Ijidakinro on 5/4/20.
//

import Foundation
import UIKit

public enum ButtonRowType {
    case Instagram
    case EqualWidths
}

open class ButtonRow: UIView {
    
    open var buttons = [UIButton]()
    open weak var rightButton:UIButton?
    open var kMargin = 5
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.draw()
    }
    
    open func addButton (button: UIButton, key:String? = nil) {
        self.addSubview(button)

        self.buttons.append(button)
        
        // If the user has set a key for this button, then store it in the dictionary
        if let key = key {
            self.buttonStorage[key] = button
        }
        
        self.draw()
        button.layoutIfNeeded()
        button.alignImageAndTitleVertically()
    }
    
    private func draw () {
        var counter = 0
        var previousButton:UIButton!
        for button in self.buttons {
            button.snp.remakeConstraints({ (make) in
                if button == buttons.first {
                    make.left.equalTo(self)
                } else {
                    make.left.equalTo(previousButton.snp.right)
                }
                
                let width = Style.getCorrectWidth() / CGFloat(integerLiteral: self.numberOfButtons)
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

