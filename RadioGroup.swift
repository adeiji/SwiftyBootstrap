//
//  RadioGroup.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 11/25/22.
//

import Foundation
import UIKit
import RxSwift

public struct RadioGroupOptions:Equatable {
    
    public static func == (lhs: RadioGroupOptions, rhs: RadioGroupOptions) -> Bool {
        return lhs.text == rhs.text
    }
    
    let text:NSAttributedString
    let closure:UIButtonTargetClosure
    
    public init(text: NSAttributedString, closure: @escaping UIButtonTargetClosure) {
        self.text = text
        self.closure = closure
    }
    
}

open class RadioGroup: GRBootstrapElement {
    
    public var selectionMade = PublishSubject<String>()
        
    public var radioSections = [RadioSection]()
    
    /// Instantiate a new RadioGroup object
    /// - Parameters:
    ///   - options: The options for the user to decide from
    ///   - color: The color that the text should be
    ///   - buttonTargetClosure: The closure to run when the button is pressed.
    public init(_ options: [RadioGroupOptions], color: UIColor) {
                
        super.init()
        
        var columns = [Column]()
        
        options.forEach { radioGroupOption in
            let radioSection = RadioSection(color: color, text: radioGroupOption.text, card: self).setup()
            let column = Column(cardSet: radioSection.toCardSet(), xsColWidth: .Twelve, anchorToBottom: radioGroupOption == options.last)
            columns.append(column)
            self.radioSections.append(radioSection)
            
            // Handle the radio button is pressed
            radioSection.radioButton?.addTargetClosure(closure: { [weak self] button in
                guard let self = self else { return }
                self.radioSections.map({ $0.selected = false })
                radioSection.selected = true
                radioGroupOption.closure( button )
            })
        }
                        
        self.addRow(columns: columns, anchorToBottom: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class RadioSection: GRBootstrapElement {
    
    private let color:UIColor
    private let text:NSAttributedString
    private let card:GRBootstrapElement
    
    public weak var radioButton:UIButton?
    
    var selected:Bool = false {
        didSet {
            self.radioButton?.layer.sublayers?.removeAll()
            if selected == true {
                self.radioButton?.layer.addSublayer(getSelectedCircleLayer(color: self.color))
            } else {
                self.radioButton?.layer.addSublayer(getUnselectedCircleLayer(color: self.color))
            }
        }
    }
    
    init(color: UIColor = .black, text: NSAttributedString, card: GRBootstrapElement) {
        self.color = color
        self.text = text
        self.card = card
        super.init()
    }
    
    
    /// Setup this object by adding the necessary the rows and columns, and setting the button targets
    /// - Parameter buttonClosure: The closure to run when the button is pressed.
    /// - Returns: The radio section (self)
    func setup () -> RadioSection {
        let radioButton = self.getCircleButton(color: color)
        
        self.addRow(columns: [
            Column(cardSet: radioButton.toCardSet().withHeight(20), xsColWidth: .One),
            Column(cardSet: Style.label(withAttributedText: self.text, color: self.color).toCardSet(), xsColWidth: .Eleven, anchorToBottom: true)
        ], anchorToBottom: true)
        
        self.radioButton = radioButton
            
        return self
    }
       
    required public init?(coder aDecoder: NSCoder) {
        self.text = NSAttributedString(string: "")
        self.card = GRBootstrapElement()
        self.color = .black
        super.init(coder: aDecoder)
    }
    
    private func getCircleButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.layer.addSublayer(self.getUnselectedCircleLayer(color: color))
        button.showsTouchWhenHighlighted = true
        return button
    }
    
    private func getSelectedCircleLayer (color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 10, y: 10), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
        let outerCircleLayer = CAShapeLayer()
        outerCircleLayer.path = circlePath.cgPath
            
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = color.cgColor
        outerCircleLayer.lineWidth = 3.0
        
        let circle = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 2.5, y: 2.5), size: CGSize(width: 15, height: 15)))
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.cgPath
        circleLayer.fillColor = color.cgColor
        
        outerCircleLayer.addSublayer(circleLayer)
                
        return outerCircleLayer
    }
    
    private func getUnselectedCircleLayer (color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 10, y: 10), radius: CGFloat(10), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 3.0
        return shapeLayer
    }
    
}
