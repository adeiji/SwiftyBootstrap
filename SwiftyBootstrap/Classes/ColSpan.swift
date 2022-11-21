//
//  ColWidth.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 8/10/22.
//

import Foundation



///The number of columns to span a UI element across. Similar to how a col span works with Bootstrap.
///
///A col span of Twelve is full screen. A col span of Six is half the screen. A col span of Three is a quarter of the screen
public enum ColSpan:CGFloat {
    case Zero = 0.0 // Don't add to the superview
    case One = 1.0
    case Two = 2.0
    case Three = 3.0
    case Four = 4.0
    case Five = 5.0
    case Six = 6.0
    case Seven = 7.0
    case Eight = 8.0
    case Nine = 9.0
    case Ten = 10.0
    case Eleven = 11.0
    case Twelve = 12.0
}
