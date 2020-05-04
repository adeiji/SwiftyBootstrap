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
    
    public init (left:CGFloat?, top:CGFloat?, right:CGFloat?, bottom:CGFloat?) {
        self.left = left ?? 20
        self.top = top ?? 20
        self.right = right ?? 20
        self.bottom = bottom ?? 20
    }
}

