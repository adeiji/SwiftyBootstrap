//
//  UIView+WithAttributes.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/19/22.
//

import Foundation
import UIKit

extension UIView {
        
    
    /**
     This is a convenience method designed to allow you to set all the attributes for the view object inline when creating a column.
     
     See the example below:
     
     ```
     let card = GRBootstrapElement()
     
     card.addRow(columns: [
         Column(UILabel().withAttributes(closure: { view in
             let label = view as? UILabel
             label?.text = "This is just an example."
         })
         .cardSet(),
         xsColSpan: .Twelve
     ], anchorToBottom: true)
     ```
     - Parameter closure: The closure to execute which should contain what attributes you want to set for this object
     - Returns: This UIView object (self)
     */
    public func withAttributes (closure: (_ view: UIView) -> Void) -> UIView {
        closure(self)        
        return self
    }
    
}
