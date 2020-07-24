//
//  String+AddLineSpacing.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 2/13/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     Adds spacing between the lines of a string
     
     - parameter amount: The amount of spacing
     - returns: The NSMutableAttributedString object with the added spacing
     */
    func addLineSpacing (amount: CGFloat = 10, centered:Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = amount // Whatever line spacing you want in points

        if centered {
            paragraphStyle.alignment = .center
        }
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
                            
        // *** Set Attributed String to your label ***
        return attributedString
    }
    
}
