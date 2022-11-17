//
//  UIButton+Simplicity.swift
//  PMUBeautyForms
//
//  Created by Adebayo Ijidakinro on 7/30/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    
    func image (_ name: String) -> UIButton {
        self.setImage(UIImage(named: name), for: .normal)
        return self
    }
    
}
