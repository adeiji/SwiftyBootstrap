//
//  GRCameraButton.swift
//  Graffiti
//
//  Created by adeiji on 4/6/18.
//  Copyright © 2018 Dephyned. All rights reserved.
//

import UIKit

public enum GRButtonType {
    case RedMapMarker
    case AddPlusSign
    case MessageBubble
    case LocationMarker
    case Heart
    case SendArrow
    case AddTagCamera
    case Menu
    case Back
    case Cancel
    case Search
    case Settings
    case Profile
    case Selection
    case Okay
    case Activity
    case TagMenu
    case TagPlace
    case SaveTag
    case Refresh
    case None
    case SprayCan
}

open class GRButton : UIButton {
    
    open var type: GRButtonType
    open var userSelected = false
    
    public init(type: GRButtonType) {
        self.type = type
        super.init(frame: .zero)
        self.contentEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        self.titleLabel?.font = UIFont(name: FontNames.allBold.rawValue, size: FontSizes.small.rawValue)
    }        
    
    open func setBackgroundColor (number: Int? = nil) {
        var num = number
        if num == nil {
            num = Int(arc4random_uniform(10))
        }
        
        switch num {
        case 0:
            self.backgroundColor = UIColor.Style.htPeach
        case 1:
            self.backgroundColor = UIColor.Style.htTeal
        case 2:
            self.backgroundColor = UIColor.Style.htBlueish
        case 3:
            self.backgroundColor = UIColor.Style.htRedish
        case 4:
            self.backgroundColor = UIColor.Style.htLightPurple
        case 5:
            self.backgroundColor = UIColor.Style.htLightBlue
        case 6:
            self.backgroundColor = UIColor.Style.htLightGreen
        case 7:
            self.backgroundColor = UIColor.Style.htLightOrange
        case 8:
            self.backgroundColor = UIColor.Style.htDarkPurple
        case 9:
            self.backgroundColor = UIColor.Style.htDookieGreen
        default:
            break;
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.type = .None
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        self.clearsContextBeforeDrawing = false
        self.showsTouchWhenHighlighted = true
        if self.type == .AddPlusSign {
            GraffitiStyle.drawAddPlusSign(frame: rect, resizing: .center)
        } else if self.type == .MessageBubble {
            GraffitiStyle.drawMessageBubble(frame: .zero, resizing: .center)
        } else if self.type == .LocationMarker {
            GraffitiStyle.drawLocationMarker(frame: .zero, resizing: .center)
        } else if self.type == .Heart {
            GraffitiStyle.drawHeart(frame: .zero, resizing: .center)
        } else if self.type == .SendArrow {
            GraffitiStyle.drawSendArrow(frame: .zero, resizing: .center)
        } else if self.type == .AddTagCamera {            
            GraffitiStyle.drawAddTagCamera(frame: .zero, resizing: .center)
        } else if self.type == .Menu {
            GraffitiStyle.drawMenu(frame: .zero, resizing: .center)
        } else if self.type == .Back     {
            GraffitiStyle.drawBack(frame: .zero, resizing: .center)
        } else if self.type == .Cancel {
            GraffitiStyle.drawCancel(frame: .zero, resizing: .center)
        } else if self.type == .Settings {
            GraffitiStyle.drawSettings(frame: .zero, resizing: .center)
        } else if self.type == .Profile {
            GraffitiStyle.drawProfile(frame: .zero, resizing: .center)
        } else if self.type == .Search {
            GraffitiStyle.drawSearch(frame: .zero, resizing: .center)
        } else if self.type == .Selection {
            GraffitiStyle.drawSelection(frame: .zero, resizing: .center, isSelected: self.userSelected)
        } else if self.type == .Okay {
            GraffitiStyle.drawOkay(frame: .zero, resizing: .center)
        } else if self.type == .Activity {
            GraffitiStyle.drawWhiteHeart(frame: .zero, resizing: .center)
        } else if self.type == .TagMenu {
            GraffitiStyle.drawSprayCan(frame: .zero, resizing: .center)
        } else if self.type == .TagPlace {
            GraffitiStyle.drawSprayCanTagPlace(frame: .zero, resizing: .center)
        } else if self.type == .SaveTag {
            GraffitiStyle.drawHouseSaveTag(frame: .zero, resizing: .center)
        } else if self.type == .RedMapMarker {
            GraffitiStyle.drawLocationRedMapMarker(frame: .zero, resizing: .center)
        } else if self.type == .Refresh {
            GraffitiStyle.drawRefresh(frame: .zero, resizing: .center)
        }
    }
    
}
