//
//  UILabelConfig.swift
//  InspectionApp
//
//  Created by Adebayo Ijidakinro on 3/14/21.
//

import Foundation
import UIKit

open class UILabelConfig {
    
    var text: String?
    var attributedText: NSAttributedString?
    
    var fontName: FontNames = FontNames.all
    var size: FontSizes = FontSizes.small
    var color: UIColor = .black
    var numberOfLines: Int = 0
    var textAlignment: NSTextAlignment = .left
    var backgroundColor: UIColor = .white
    
    public init(text: String? = nil, attributedText: NSAttributedString? = nil) {
        self.text = text
        self.attributedText = attributedText
    }
    
    open func setFontName (_ fontName: FontNames) -> UILabelConfig {
        self.fontName = fontName
        return self
    }
    
    open func setText (_ text: String) -> UILabelConfig {
        self.text = text
        return self
    }
    
    open func setSize (_ size: FontSizes) -> UILabelConfig {
        self.size = size
        return self
    }

    open func setColor (_ color: UIColor) -> UILabelConfig {
        self.color = color
        return self
    }
    
    open func setNumberOfLines (_ numberOfLines: Int) -> UILabelConfig {
        self.numberOfLines = numberOfLines
        return self
    }
    
    open func setTextAlignment (_ textAlignment: NSTextAlignment) -> UILabelConfig {
        self.textAlignment = textAlignment
        return self
    }
    
    open func setBackgroundColor (_ color: UIColor) -> UILabelConfig {
        self.backgroundColor = color
        return self
    }
    
    open func setAttributedText (_ attributedText: NSAttributedString) -> UILabelConfig {
        self.attributedText = attributedText
        return self
    }

}

extension Style {
    open class func label (_ config: UILabelConfig) -> UILabel {
        let font = UIFont.init(name: config.fontName.rawValue, size: config.size.rawValue)
        let label = UILabel()
        if config.attributedText != nil {
            label.attributedText = config.attributedText
        } else {
            label.text = config.text
        }
        
        label.font = font
        label.textColor = config.color
        label.numberOfLines = config.numberOfLines
        label.backgroundColor = config.backgroundColor
        label.textAlignment = config.textAlignment
                
        return label
    }
}

