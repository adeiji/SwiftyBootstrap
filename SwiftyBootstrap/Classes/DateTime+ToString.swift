//
//  DateTime+ToString.swift
//  GraffitiAdmin
//
//  Created by Adebayo Ijidakinro on 12/6/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation

public extension Date {
    
    // Returns just the time as a string of a date
    func toTimeString () -> String {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        
        return df.string(from: self)
    }
    
}
