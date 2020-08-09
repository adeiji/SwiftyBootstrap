//
//  GRTutorial.swift
//  PMUBeautyForms
//
//  Created by Adebayo Ijidakinro on 8/1/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

public enum TutorialMessageLocation {
    case top
    case bottom
    case left
    case right
}

public struct TutorialStep {
    
    /// The element to highlight
    let element:UIView?
    
    /// The text to display to the user
    let message:String
    
    /// Where to display the message relative to the element
    let messageLocation:TutorialMessageLocation
    
    var showNavButtons:Bool = false
    
    var fullWidth:Bool = false
    
    var highlightContent:Bool = false
    
    var customButtonAction:TutorialButtonAction = nil
    
    var showOnTop:Bool = false
    
    var showArrow:Bool = true
    
    public init(element: UIView?, message:String, messageLocation: TutorialMessageLocation, showNavButtons:Bool = false, fullWidth: Bool = false, highlightContent:Bool = false, customButtonAction:TutorialButtonAction = nil, showOnTop:Bool = false, showArrow:Bool = false) {
        self.element = element
        self.message = message
        self.messageLocation = messageLocation
        self.showNavButtons = showNavButtons
        self.fullWidth = fullWidth
        self.highlightContent = highlightContent
        self.customButtonAction = customButtonAction
        self.showOnTop = showOnTop
        self.showArrow = showArrow
    }
    
}

public typealias TutorialButtonAction = (() -> Void)?

public struct TutorialButtons {
    var next:UIButton?
    var prev:UIButton?
}

public protocol GRTutorial: GRTutorialViewController {
    
    var tutorialSteps:[TutorialStep] { get set }
    
    var currentTutorialPosition:Int { get set }
        
}

public extension GRTutorial {
    
    private func showStep (_ step: TutorialStep, superview:UIView? = nil) {
        
        let transparentView = TutorialStepView(fullWidthMask: step.fullWidth)
        transparentView.transparentHoleView = step.element
        transparentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let superview:UIView! = superview ?? self.view
        
        superview.addSubview(transparentView)
        
        self.tutorialView = transparentView
        transparentView.layer.zPosition = 100
        
        if step.showOnTop {
            transparentView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view)
                make.top.equalTo(self.view)
                make.right.equalTo(self.view)
            }
        } else {
            transparentView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
                
        transparentView.isUserInteractionEnabled = false
        
        let view = UIView()
        transparentView.addSubview(view)
        if let element = step.element {
            if step.highlightContent {
                element.layer.borderWidth = 3.0
                element.layer.borderColor = UIColor.yellow.cgColor
            }
            
            view.frame = (element.convert(element.frame, to: self.view))
            transparentView.maskElement = view
        }
                
        if let navButtons = transparentView.showStep(step: step) {
            transparentView.isUserInteractionEnabled = true
            
            navButtons.next?.addTargetClosure { [weak self] (_) in
                guard let self = self else { return }
                
                if let action = step.customButtonAction {
                    action()
                    return
                }
                
                step.element?.layer.borderWidth = 0
                step.element?.layer.borderColor = nil
                
                transparentView.removeFromSuperview()
                
                self.currentTutorialPosition += 1
                if self.currentTutorialPosition < self.tutorialSteps.count {
                    self.showStep(self.tutorialSteps[self.currentTutorialPosition])
                } else {
                    GRTutorialManager.shared.tutorialMode = nil
                    transparentView.removeFromSuperview()
                }
            }
        }
    }
    
    func showTutorial (_ superview: UIView? = nil) {
        guard let step = self.tutorialSteps.first else { return }
        self.showStep(step)
    }
    
    func addTutorialStep (_ step: TutorialStep) {
        self.tutorialSteps.append(step)
    }
    
}

public class TutorialStepView: UIView {
    
    @IBOutlet weak var transparentHoleView: UIView!
    
    var maskElement:UIView?
    
    let fullWidthMask:Bool
    
    init(fullWidthMask: Bool = false) {
        self.fullWidthMask = fullWidthMask
        super.init(frame: .zero)
    }
    
    func addNavButtons (infoCard: GRBootstrapElement, location: TutorialMessageLocation) -> TutorialButtons {
        
        let nextButton = Style.clearButton(with: "", superview: nil, backgroundColor: UIColor.Style.htDarkPurple).image("next")
        nextButton.layer.borderWidth = 0.0
        
        infoCard.addRow(columns: [
            Column(cardSet: nextButton.radius(radius: 25).toCardSet().withHeight(50), xsColWidth: .Twelve, anchorToBottom: true, centeredWidth: 50)
        ], anchorToBottom: true)
        
        return TutorialButtons(next: nextButton, prev: nil)
    }
    
    private func showStepWithNoHighlightedElement (infoCard: GRBootstrapElement, step:TutorialStep) -> TutorialButtons? {
        infoCard.addRow(columns: [
            Column(cardSet: Style.label(withText: step.message, size: .medium, superview: nil, color: .white, textAlignment: .center).toCardSet(), xsColWidth: .Twelve)
        ], anchorToBottom: step.showNavButtons == false)
        
        self.addSubview(infoCard)
        
        infoCard.snp.makeConstraints { (make) in
            if step.showOnTop {
                make.top.equalTo(self)
                make.bottom.equalTo(self)
            } else {
                make.centerY.equalTo(self)
            }
            
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        if step.showNavButtons {
            return self.addNavButtons(infoCard: infoCard, location: step.messageLocation)
        }
        
        return nil
    }
    
    private func showStepOnBottomWithHighlightedElement (infoCard: GRBootstrapElement, step: TutorialStep) -> TutorialButtons? {
        let imageView = UIImageView(image: UIImage(named: "up-arrow"))
        
        if step.showArrow {
            infoCard.addRow(columns: [
                Column(cardSet: imageView.toCardSet().margin.top(50), xsColWidth: .Twelve, centeredWidth: 100)
            ], anchorToBottom: false)
        }
        
        infoCard.addRow(columns: [
            Column(cardSet: Style.label(withText: step.message, size: .medium, superview: nil, color: .white, textAlignment: .center).toCardSet(), xsColWidth: .Twelve)
        ], anchorToBottom: step.showNavButtons == false)
        
        infoCard.addToSuperview(superview: self, viewAbove: self.maskElement)
        
        if step.showNavButtons {
            return self.addNavButtons(infoCard: infoCard, location: step.messageLocation)
        }
        
        return nil
    }
    
    private func showStepOnTopWithHighlightedElement (infoCard: GRBootstrapElement, step: TutorialStep) -> TutorialButtons? {
        let imageView = UIImageView(image: UIImage(named: "up-arrow"))
        let degrees:CGFloat = 180; //the value in degrees
        imageView.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi)/180);
        infoCard.backgroundColor = .clear
        
        infoCard.addRow(columns: [
            Column(cardSet: Style.label(withText: step.message, size: .medium, superview: nil, color: .white, textAlignment: .center).toCardSet(), xsColWidth: .Twelve),
            Column(cardSet: imageView.toCardSet().margin.top(50), xsColWidth: .Twelve, centeredWidth: 100)
        ], anchorToBottom: step.showNavButtons == false)
        
        self.addSubview(infoCard)
        
        infoCard.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.maskElement?.snp.top ?? self.snp.bottom).offset(-50)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        if step.showNavButtons {
            return self.addNavButtons(infoCard: infoCard, location: step.messageLocation)
        }
        
        return nil
    }
    
    /**
     Show a tutorial step on the screen.  The tutorial step contains all the basic information necessary for the tutorial.  Example, the message, a button, an arrow, etc.
     */
    func showStep (step: TutorialStep ) -> TutorialButtons? {
                
        let infoCard = GRBootstrapElement(color: .clear)
        
        if self.maskElement == nil {
            return self.showStepWithNoHighlightedElement(infoCard: infoCard, step: step)
        } else {
            switch step.messageLocation {
            case .bottom:
                return self.showStepOnBottomWithHighlightedElement(infoCard: infoCard, step: step)
            case .top:
                return self.showStepOnTopWithHighlightedElement(infoCard: infoCard, step: step)
            default:
                break
            }
        }
        
        return nil
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.transparentHoleView != nil {
            // Ensures to use the current background color to set the filling color
            self.backgroundColor?.setFill()
            UIRectFill(rect)
            
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            
            // Make hole in view's overlay
            // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
            guard let superview = self.superview else { return }
            
            var maskRect = transparentHoleView.convert(transparentHoleView.bounds, to: superview)
            
            if self.fullWidthMask {
                maskRect = CGRect(x: CGFloat(0), y: maskRect.minY - 10, width: superview.frame.width, height: maskRect.height + 20)
            }
            
            path.addRect(maskRect)
            path.addRect(bounds)

            
            layer.path = path
            layer.fillRule = CAShapeLayerFillRule.evenOdd
            self.layer.mask = layer
        } else {
            self.backgroundColor = .clear
        }
    }
    
    override public func layoutSubviews () {
        super.layoutSubviews()
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        self.fullWidthMask = false
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.fullWidthMask = false
        super.init(frame: frame)
    }
}

extension UIView {
    private func imageRepresentation () -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    private func imageRepresentationWithTintColor (color: UIColor) -> UIImage? {
        guard let image = self.imageRepresentation() else { return nil }
        let tintedImage = self.tintedImage(image: image, usingColor: color)
        return tintedImage
    }
    
    private func tintedImage (image: UIImage, usingColor tintColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        let drawRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: drawRect)
        tintColor.set()
        UIRectFillUsingBlendMode(drawRect, .darken)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
        
    }
    
    func tint (color: UIColor) {
        self.tintColor = color
        let tintImage = self.imageRepresentationWithTintColor(color: color)
        let tintImageView = UIImageView(image: tintImage)
        tintImageView.layer.zPosition = -100
        self.addSubview(tintImageView)
        tintImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
}
