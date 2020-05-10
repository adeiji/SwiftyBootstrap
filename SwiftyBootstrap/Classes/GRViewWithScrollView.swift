//
//  GRViewWithScrollView.swift
//  GraffitiAdmin
//
//  Created by Adebayo Ijidakinro on 12/5/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

open class GRContainerView : UIView {
    
    open weak var activeField:UITextField?
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.activeField?.resignFirstResponder()
    }
}

open class GRViewWithScrollView : UIView, UITextFieldDelegate {
    
    open weak var navBar:GRNavBar!
    open weak var scrollView:UIScrollView!
    open weak var containerView:GRContainerView!
    open weak var activeField:UITextField?
    open weak var loadingView:UIView?
    
    open var keyboardHeight:CGFloat?
    
    // When a text field is clicked and the keyboard shows and the scroll view scrolls in order to show the text field
    // this is the amount extra or less than you want the scroll view to scroll
    open var scrollWhenTextFieldClickedOffset:CGFloat = 0
    
    /// Show a white faded screen with a spinner in the middle indicating that there is a action in progress
    open func showLoading (superview: UIView? = nil) {
        
        let fadedView = UIView()
        
        if let superview = superview {
            superview.addSubview(fadedView)
        } else {
            self.addSubview(fadedView)
        }
        
        fadedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        fadedView.backgroundColor = .white
        fadedView.layer.opacity = 0.7
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        fadedView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(fadedView)
        }
        
        self.loadingView = fadedView
    }
        
    /// Remove the white faded screen showing the action in progress is done
    open func hideLoading () {
        self.loadingView?.removeFromSuperview()
    }
    
    private func addScrollViewAndContainerView () {
        
        let scrollView = UIScrollView()
        
        self.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.alwaysBounceVertical = true
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self.navBar.snp.bottom)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        let containerView = GRContainerView();
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        self.containerView = containerView
    }
    
    
    
    /// Creates the ConferenceMainPageView UI Elements and layouts
    ///
    /// - Returns: The ConferenceMainPageView
    @discardableResult
    open func setup (superview: UIView, navBarHeaderText:String = "Graffiti") -> GRViewWithScrollView {
        superview.addSubview(self)
        self.registerForKeyboardNotifications()
        self.navBar = Style.navBar(withHeader: navBarHeaderText, superview: self, leftButton: nil, rightButton: nil);

        self.addScrollViewAndContainerView()
        self.backgroundColor = .white;
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(superview)
        }
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.containerView.bounds.size.height)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        return self;
    }
    
    @objc private func rotated () {
        self.containerView.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(Style.getCorrectWidth())        
        }
    }
    
    open func updateScrollViewContentSize () {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.containerView.bounds.size.height)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        self.keyboardHeight = kbSize.height
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height + self.scrollWhenTextFieldClickedOffset, right: 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = self.containerView.frame;
        aRect.size.height -= kbSize.height;
        
        if let activeField = self.activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height + 100 )
                self.scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func onKeyboardDisappear(_ notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
        self.containerView.activeField = self.activeField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
        self.containerView.activeField = self.activeField
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.activeField?.resignFirstResponder()
    }
}
