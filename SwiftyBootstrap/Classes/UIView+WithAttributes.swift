//
//  UIView+WithAttributes.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/19/22.
//

import Foundation
import UIKit

extension UIView {
        
    public func withAttributes (closure: (_ view: UIView) -> Void) {
        closure(self)
    }
    
}
