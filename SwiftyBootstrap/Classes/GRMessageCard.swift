//
//  GRMessageCard.swift
//  EZRemember
//
//  Created by Adebayo Ijidakinro on 5/6/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

/**
 This is a simple helper class that extends GRBootstrapElement.  It contains nothing more than a message and a button that says "Okay" by default
 
 By default, when the okayButton is pressed it will simply close the card, however, you can override this functionality simply by changing the target of the okayButton property.
 
 There is also much more that you can do, for example you can...
 1. Add a second button.
 2. Add a text field
 
 And then since it's an instance of GRBootstrapSection you can add rows like any other BootstrapElement. However, if you're going to be doing a lot of customization then you may as well just use GRBootstrapElement directly
 */
open class GRMessageCard: GRBootstrapElement {
             
    /** This is the top button. It by default is the okay button. */
    open weak var firstButton:UIButton?
    
    /**
    This is the bottom button.
     
    If in the draw method you set the text for the cancelButtonText parameter, then a second button will automatically be created that should be for canceling an action. However, technically you can use it for any purpose
     */
    open weak var secondButton:UIButton?
    
    /** When the message card displays a view that blurs the superview is added which blurs out the screen to easier see the message card*/
    private var blurView: UIView?
    
    /** Whether or not to add a text field to the message card */
    private var addTextField:Bool
    
    /** Whether or not the card appeared by coming down from the top or coming up from the bottom */
    private var showFromTop = false
    
    /** The placeholder text for the text field if there is one added to the card*/
    private var textFieldPlaceholder = ""
    
    /** The text field that is added to the message card, if there is one added. See addTextField:Bool*/
    open weak var textField:UITextField?
    
    /** The label that displays the main information on the message card*/
    open weak var messageLabel:UILabel?
            
    /// Create a new instance of the GRMessageCard class
    /// - Parameters:
    ///   - color: The background color of the card, defaults to white
    ///   - anchorWidthToSuperviewWidth: Whether or not to anchor the width of this card to the width of it's superview
    ///   - margin: The margin to display around the card. Of type BoostrapMargin
    ///   - superview: The superview to add this message card to
    public override init(color: UIColor? = .white, anchorWidthToSuperviewWidth: Bool = true, margin: BootstrapMargin? = nil, superview: UIView? = nil) {
        self.addTextField = false
        super.init(color: color, anchorWidthToSuperviewWidth: anchorWidthToSuperviewWidth, margin: margin, superview: superview)
    }
    
    /** Set whether or not to show this message card from the top */
    func setShowFromTop (_ show: Bool) {
        self.showFromTop = show
    }
    
    
    /// Create an instance of GRMessageCard
    /// - Parameters:
    ///   - addTextField: Whether or not to add a text field to the card
    ///   - textFieldPlaceholder: The placeholder for the text field
    ///   - showFromTop: Whether or not to show the message card slide down from the top. If set to true, slides down from top, if false, slides up from bottom
    convenience init(addTextField: Bool, textFieldPlaceholder:String, showFromTop: Bool) {
        self.init()
        self.addTextField = addTextField
        self.showFromTop = showFromTop
        self.textFieldPlaceholder = textFieldPlaceholder
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds a button that is simply an x, that when slides the card out of view and removes it from it's superview
    func addExitButton () {
        let exitButton = UIButton()
        
        if #available(iOS 12.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                exitButton.setImage(UIImage(named: "close-white"), for: .normal)
            } else {
                exitButton.setImage(UIImage(named: "close-black"), for: .normal)
            }
        } else {
            // Fallback on earlier versions
            exitButton.setImage(UIImage(named: "close-black"), for: .normal)
        }
        
        self.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(10)
        }
        
        exitButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    /**
     Displays the message card on the screen with the given parameters.  It also blurs the view that is responsible for showing it
     
     - Note: You don't need to add this view to the superview yourself, it will do so automatically
     
     - Important: If you want a cancel button than you must set the cancelButtonText.
     
     - parameters:
        - message: The message to display
        - title: The title of the message which goes at the top in large letters
        - buttonBackgroundColor: What color you want the button to be?
        - superview: What view is responsible for showing this view?
        - buttonText: What do you want the button to say?
        - cancelButtonText: Do you want a cancel button? If so, what do you want the text to say? **If you don't set this property, there will be no cancel button**
     */
    public func draw (message: String, title:String, buttonBackgroundColor:UIColor = .black, superview: UIView, buttonText: String = "Okay", cancelButtonText:String? = nil, isError: Bool = false) {
        let okayButton = self.largeButton(with: buttonText, backgroundColor: buttonBackgroundColor)
        okayButton.showsTouchWhenHighlighted = true
        okayButton.layer.cornerRadius = 5.0
        
        let messageLabel = self.label(withText: message, superview: nil, color: isError ? .red : UIColor.black)
        
        let cancelButton = self.largeButton(with: cancelButtonText ?? "", backgroundColor: .lightGray, fontColor: .darkGray)
        cancelButton.showsTouchWhenHighlighted = true
        cancelButton.isHidden = cancelButtonText == nil
        cancelButton.layer.cornerRadius = 5.0
        
        let blurView = self.addBlurView(superview: superview)
        self.blurView = blurView
        
        self
        .addRow(columns: [
            
            // TITLE
            
            Column(self.label(withText: title, superview: nil, color: UIColor.black)
                .cardSet()
                .margin.left(30)
                .margin.right(30)
                .margin.top(30),
                   xsColSpan: .Twelve),
            
            // MESSAGE
            
            Column(messageLabel
                .cardSet()
                .margin.left(30)
                .margin.right(30)
                .margin.top(30),
                   xsColSpan: .Twelve)
            ])
        
        if (self.addTextField) {
            let textField = self.wideTextField(withPlaceholder: self.textFieldPlaceholder, superview: nil, color: .black)
            textField.autocorrectionType = .yes
            self.addRow(columns: [
                Column(textField
                    .cardSet()
                    .margin.left(25)
                    .margin.right(25),
                       xsColSpan: .Twelve)
            ])
            self.textField = textField
        }
        
        self.addRow(columns: [
                
                // OKAY BUTTON
                
                Column(okayButton
                    .cardSet()
                    .margin.bottom(10)
                    .margin.left(30)
                    .margin.right(30),
                       xsColSpan: .Twelve),
                
                // CANCEL BUTTON
                
                Column(cancelButton
                .cardSet()
                .margin.top(0)
                .margin.left(30)
                .margin.right(30)
                .margin.bottom(30),
                   xsColSpan: .Twelve)
            ], anchorToBottom: true)
                
        if self.showFromTop {
            self.slideDown(superview: superview, margin: 20, width: GRDevice.smallerThan(.sm) ? nil : 350)
        } else {
            self.slideUp(superview: superview, margin: 20, width: GRDevice.smallerThan(.sm) ? nil : 350)
        }
        
        okayButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(close), for: .touchUpInside)
                
        
        self.firstButton = okayButton
        self.secondButton = cancelButton
        
        
        self.layer.cornerRadius = 10
    }
    
    private func wideTextField (withPlaceholder: String, superview: UIView?, color: UIColor, autocorrection: UITextAutocorrectionType = UITextAutocorrectionType.no) -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: withPlaceholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: color])
        textField.textColor = color
        textField.autocorrectionType = autocorrection
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        if let superview = superview {
          superview.addSubview(textField)
        }
        return textField
    }
    
    private func largeButton (with title: String, superview: UIView? = nil, backgroundColor:UIColor? = nil, borderColor:UIColor? = nil, fontColor:UIColor? = nil, imageName:String? = nil) -> UIButton {
                        
        let button = UIButton()
        
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
            return button
        }
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 0.5
        }
        
        if let fontColor = fontColor {
            button.setTitleColor(fontColor, for: .normal)
        }
        
        if let superview = superview {
            superview.addSubview(button)
        }
        
        button.showsTouchWhenHighlighted = true
        
        return button;
    }
    
    private func label (withText: String, superview: UIView!, color: UIColor, numberOfLines:Int = 0, textAlignment: NSTextAlignment = .left, backgroundColor: UIColor? = nil) -> UILabel {
        
        let label = UILabel()
        label.text = withText
        label.textColor = color
        label.numberOfLines = numberOfLines
        if superview != nil {
            superview.addSubview(label)
        }
        if let backgroundColor = backgroundColor {
            label.backgroundColor = backgroundColor
        }
        label.textAlignment = textAlignment
                
        return label
    }
    
    /**
     Slide the message card out of view and removes it from the superview.
     
     - Important: It is recommended that you use this function to remove this card from the superview. You can remove it manually, however, there are certain clean up tasks that are executed within this method also.
     */
    @objc open func close () {
        if let superview = self.superview {
            if self.showFromTop {
                self.slideUpAndRemove(superview: superview)
                self.blurView?.removeFromSuperview()
            } else {
                self.slideDownAndRemove(superview: superview)
                self.blurView?.removeFromSuperview()
            }
            
        }
    }
    
    
    /// Adds a view that blurs out it's superview
    /// - Parameter superview: The view to blur out. The superview of the blur view
    /// - Returns: A reference to the blur view
    private func addBlurView (superview: UIView) -> UIView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = true
        superview.addSubview(blurEffectView)
        
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(superview)
        }
        
        return blurEffectView
    }
}

