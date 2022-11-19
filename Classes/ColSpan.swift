//
//  ColSpan.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 8/10/22.
//

import Foundation

/**
 The widths which are used to determine the size of a column
 This is based off of the bootstrap way of handling sizing.
 
 The screen width is split into twelve, and the number you pick is the number of columns that the item will span across.
 
 So a...
 - ColSpan of 6 is half the screen
 - ColSpan of 3 is a quarter of the screen
 - ColSpan of 12 is full screen
 */
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
