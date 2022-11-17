//
//  Array+RemoveDuplicates.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 11/5/19.
//  Copyright © 2019 Dephyned. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    
    func removingDuplicates () -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates () {
        self = self.removingDuplicates()
    }
    
}
