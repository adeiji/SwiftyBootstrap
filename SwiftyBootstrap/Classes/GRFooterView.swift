//
//  GRFooterView.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 2/7/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

open class GRFooterView: ButtonRow {
            
    func getButtonByKey (key: String) -> UIButton? {
        return self.buttonStorage[key]
    }
    
    /**
     Create a button that will be displayed in the footer
     - parameters:
        - title: The title to display underneath the button
        - imageName: The image to displaly for the button
     
     - returns: The button to be displayed in the footer
     */
    static func getFooterButton (title: String, imageName: String) -> UIButton {
        let button = Style.clearButton(
            with: title, superview: nil,
            fontSize: Style.getScreenSize() == .xs ? .verySmall : .small,
            color: UIColor.Style.darkBlueGrey.dark(.lightGray))
        button.tintColor = .gray
        button.setImage(UIImage(named: imageName), for: .normal)
        
        return button
    }
            
    init(superview: UIView, height:CGFloat, numberOfButtons: Int) {
        super.init(numberOfButtons: numberOfButtons)
        superview.addSubview(self)
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(height)
        }
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
