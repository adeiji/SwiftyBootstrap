//
//  GRTextViewPlaceHolderProcol.swift
//  GraffitiAdmin
//
//  Created by Adebayo Ijidakinro on 12/6/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation
import SnapKit

public protocol GRTextViewPlaceHolderProtocol {
    
    var textViewPlaceholder:String? { get set }
    var textView: UITextView? { get set }
    var textViewBottomConstraint:Constraint? { get set }
    
    func beginEditing(_ textView: UITextView)
    func endEditing(_ textView: UITextView)
}

extension GRTextViewPlaceHolderProtocol {
    
    func beginEditing(_ textView: UITextView) {
        guard
            let textViewPlaceholder = textViewPlaceholder
        else {
            return
        }
        
        if textView.text == textViewPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func endEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewPlaceholder
        }
    }
    
}
