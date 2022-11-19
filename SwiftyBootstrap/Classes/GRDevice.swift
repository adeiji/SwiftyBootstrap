//
//  GRDevice.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/17/22.
//

import Foundation

/// Checks to see which size the current device falls under
/// For more information see documentation for GRCurrentDevice
open class GRDevice {
    
    open class func smallerThan (_ size: DeviceSizes) -> Bool {
        let currentSize = GRCurrentDevice.shared.size
        switch size {
        case .sm:
            return currentSize == .xs
        case .md:
            return currentSize == .xs || currentSize == .sm
        case .lg:
            return currentSize == .md || currentSize == .xs || currentSize == .sm
        case .xl:
            return currentSize == .lg || currentSize == .md || currentSize == .xs || currentSize == .sm
        default:
            return false
        }
    }
}

// The sizes class will handle the sizing of the device/interface
public enum DeviceSizes: CaseIterable {
    /// iPhone width or slim view of the iPad
    case xs
    /// less than iPad full width or half of screen in landscape
    case sm
    /// Portrait of an iPad
    case md
    /// It's either a normal iPad landscape, or iPad Pro 12.9inch portrait
    case lg
    /// iPad Pro 12.9 inch landscape
    case xl
}
