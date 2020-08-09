//
//  GRTutorialViewController.swift
//  PMUBeautyForms
//
//  Created by Adebayo Ijidakinro on 8/3/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

open class GRTutorialViewController: UIViewController, GRTutorial {
    
    public var tutorialSteps: [TutorialStep] = []
    
    public var currentTutorialPosition: Int = 0
    
    weak var tutorialView:UIView?
    
    public var tutorialMode:Bool = false
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.tutorialView?.removeFromSuperview()
        self.tutorialSteps = []
    }
}
