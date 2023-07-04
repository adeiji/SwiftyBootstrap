//
//  NSAttributedString+EasyAttribute.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 2/23/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    private var boldFont:UIFont { return UIFont(name: FontNames.allBold.rawValue, size: FontSizes.small.rawValue) ?? UIFont.boldSystemFont(ofSize: FontSizes.small.rawValue) }
    private var normalFont:UIFont { return UIFont(name: FontNames.all.rawValue, size: FontSizes.small.rawValue) ?? UIFont.systemFont(ofSize: FontSizes.small.rawValue)}
    
    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
     /// - Parameter style: value for style you wish to assign to the text.
     /// - Returns: a new instance of NSAttributedString with given strike through.
     public func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
         self.addAttribute(.strikethroughStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: string.count))
         return self
     }
    
    public func getBoldWithFontSize (_ size: CGFloat?) -> UIFont {
        guard let size = size else { return self.boldFont }
        return UIFont(name: FontNames.allBold.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    public func getNormalWithFontSize (_ size: CGFloat?) -> UIFont {
        guard let size = size else { return self.normalFont }
        return UIFont(name: FontNames.allBold.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    public func color (_ color: UIColor) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .foregroundColor : color
        ]
        
        self.addAttributes(attributes, range: NSMakeRange(0, self.length))
        return self
    }
    
    public func skipLine () -> NSMutableAttributedString {
        self.append(NSAttributedString(string: "\n\n"))
        return self
    }
    
    public func newLine () -> NSMutableAttributedString {
        self.append(NSAttributedString(string: "\n"))
        return self
    }
    
    public func bold(_ value:String, size: CGFloat? = nil) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : size == nil ? boldFont : self.getBoldWithFontSize(size)
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func normal(_ value:String, size: CGFloat? = nil) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : size == nil ? normalFont : self.getNormalWithFontSize(size),
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    public func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
}
