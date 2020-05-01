//
//  UIColor+Style.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 9/30/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    struct Style {
        // Hashtag Backgrounds
        static var htPeach: UIColor  { return UIColor(red: 253/255, green: 170/255, blue: 146/255, alpha: 1) }
        static var htTeal: UIColor  { return UIColor(red: 36/255, green: 216/255, blue: 191/255, alpha: 1) }
        static var htBlueish: UIColor  { return UIColor(red: 106/255, green: 173/255, blue: 247/255, alpha: 1) }
        static var htRedish: UIColor  { return UIColor(red: 215/255, green: 121/255, blue: 117/255, alpha: 1) }        
        static var htLightBlue: UIColor  { return UIColor(red: 99/255, green: 193/255, blue: 225/255, alpha: 1) }
        static var htLightGreen: UIColor  { return UIColor(red: 118/255, green: 229/255, blue: 184/255, alpha: 1) }
        static var htLightOrange: UIColor  { return UIColor(red: 254/255, green: 204/255, blue: 151/255, alpha: 1) }
        static var htDarkPurple: UIColor  { return UIColor(red: 143/255, green: 136/255, blue: 252/255, alpha: 1) }
        static var htLightPurple: UIColor  { return UIColor(red: 116/255, green: 124/255, blue: 169/255, alpha: 1) }
        static var htDookieGreen: UIColor  { return UIColor(red: 205/255, green: 219/255, blue: 57/255, alpha: 1) }
        static var htMintGreen: UIColor { return UIColor(red: 138/255, green: 213/255, blue: 173/255, alpha: 1) }
        static var htLightGreenishBlue: UIColor { return UIColor(red: 93/255, green: 238/255, blue: 197/255, alpha: 1) }
        static var backgroundColor: UIColor { return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) }
        
        static var beige: UIColor { return UIColor(red: 241/255, green: 237/255, blue: 226/255, alpha: 1) }
        static var blueGrey: UIColor  { return UIColor(red: 97/255, green: 125/255, blue: 138/255, alpha: 1) }
        static var orange: UIColor  { return UIColor(red: 255/255, green: 158/255, blue: 112/255, alpha: 1) }
        static var textFieldBlueGrey: UIColor  { return UIColor(red: 78/255, green: 101/255, blue: 109/255, alpha: 1) }
        static var lightGray: UIColor  { return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1) }
        static var lineGrayColor: UIColor  { return UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1) }
        static var header: UIColor { return UIColor.Style.lightGray }
        static var darkBlueGrey: UIColor { return UIColor(red: 60/255, green: 66/255, blue: 81/255, alpha: 1) }
        static var blueGrayVariant: UIColor { return UIColor(red: 76/255, green: 83/255, blue: 100/255, alpha: 1) }
        static var lightBlue: UIColor { return UIColor(red: 117/255, green: 139/255, blue: 175/255, alpha: 1)}
        static var grayish: UIColor { return UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1)}
        static var tagTagBackground: UIColor { return UIColor.Style.blueGrayVariant }
        static var followButton: UIColor { return UIColor.Style.orange }
        static var inviteFacebookButton: UIColor { return UIColor.Style.orange }
        static var navBarText: UIColor { return UIColor.Style.darkBlueGrey }
    }
    
    struct Pinterest {
        
        static var oceanBlue: UIColor { return UIColor(red: 59/255, green: 125/255, blue: 132/255, alpha: 1) }
        static var aquaBlue: UIColor { return UIColor(red: 114/255, green: 188/255, blue: 195/255, alpha: 1) }
        static var lightYellow: UIColor { return UIColor(red: 249/255, green: 235/255, blue: 193/255, alpha: 1) }
        static var lightPink: UIColor { return UIColor(red: 249/255, green: 193/255, blue: 183/255, alpha: 1) }
        static var darkerPink: UIColor { return UIColor(red: 249/255, green: 147/255, blue: 159/255, alpha: 1) }
        
    }
}
