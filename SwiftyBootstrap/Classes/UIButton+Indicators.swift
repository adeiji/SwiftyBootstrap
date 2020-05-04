//
//  UIButton+Indicators.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 9/30/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import NVActivityIndicatorView

extension UIButton {
    func addBadge (badge: Badge) {
        self.addSubview(badge)
        badge.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self.snp.top).offset(25)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        badge.layer.cornerRadius = 12.5
    }
}

extension UIView {
    
    func showLoadingNVActivityIndicatorView (color: UIColor? = nil) -> NVActivityIndicatorView {
        let activityIndicator = NVActivityIndicatorView(frame: .zero)
        activityIndicator.type = .ballClipRotate
        activityIndicator.color = color ?? UIColor.Style.darkBlueGrey
        activityIndicator.layer.zPosition = 5
        activityIndicator.startAnimating()
        self.superview?.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.isHidden = true
        
        return activityIndicator
    }
    
    /// Stop animation the given activityIndicatorView and remove it from the view
    func showFinishedLoadingNVActivityIndicatorView (activityIndicatorView: NVActivityIndicatorView?) {
        guard
            let activityIndicatorView = activityIndicatorView
        else {
            return
        }
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        self.isHidden = false
    }
    
    /// Adds a UIActivityIndicatorView to the middle of the view and starts it.  Hides the current view but shows the activity indicator view
    ///
    /// - parameter addToSuperview: Whether to add the loading indicator to this view's superview, or to this view
    ///
    /// - returns: The started UIActivityIndicatorView
    @discardableResult func showLoading (addToSuperview: Bool = true) -> UIActivityIndicatorView {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = .black
        activityIndicator.layer.zPosition = 5
        activityIndicator.startAnimating()
        
        if addToSuperview {
            self.superview?.addSubview(activityIndicator)
            self.isHidden = true
        } else {
            self.addSubview(activityIndicator)
        }                 
         
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        return activityIndicator
    }
    
    /// Stop animation the given activityIndicatorView and remove it from the view
    func showFinishedLoading (activityIndicatorView: UIActivityIndicatorView?) {
        guard
            let activityIndicatorView = activityIndicatorView
        else {
            return
        }
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        self.isHidden = false
        
    }
    
}
