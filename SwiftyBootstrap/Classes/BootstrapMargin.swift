//
//  BootstrapMargin.swift
//  Pods
//
//  Created by Adebayo Ijidakinro on 5/4/20.
//

import Foundation

/**
 Margin that it used specifically within the GRBootstrapElement class. This is the outer margin of the object
 */
public struct BootstrapMargin {
    let left:CGFloat
    let top:CGFloat
    let right:CGFloat
    let bottom:CGFloat
    
    public init (left:CGFloat? = 20, top:CGFloat? = 20, right:CGFloat? = 20, bottom:CGFloat? = 20) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
}

