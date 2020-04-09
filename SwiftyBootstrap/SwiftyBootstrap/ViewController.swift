//
//  ViewController.swift
//  SwiftyBootstrap
//
//  Created by Adebayo Ijidakinro on 4/9/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let card = GRBootstrapElement()
        
        card
            .addRow(columns: [
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(75), colWidth: .Four),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50),colWidth: .Four),
                Column(cardSet:Style.largeButton(with: "Okay", superview: nil,backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Twelve),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four)
            ]).addRow(columns: [
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four),
                Column(cardSet: Style.largeButton(with: "Okay", superview: nil, backgroundColor: UIColor.Pinterest.aquaBlue).toCardSet().withHeight(50), colWidth: .Four)
            ]).addRow(columns: [
                Column(cardSet: Style.label(withText: "This is Cool", superview: nil, color: .black, textAlignment: .center).toCardSet(), colWidth: .Twelve)
                    .addRow(columns: [
                        Column(cardSet: Style.largeButton(with: "Oh Yeah").toCardSet(), colWidth: .Twelve),
                    ])
            ])
                                    
        card.addToSuperview(superview: self.view, top: 40.0)
    }
}

