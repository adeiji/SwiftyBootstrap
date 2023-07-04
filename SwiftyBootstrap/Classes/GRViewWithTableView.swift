//
//  GRViewWithTableView.swift
//  GraffitiAdmin
//
//  Created by Adebayo Ijidakinro on 1/25/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class GRViewWithTableView : UIView {
    
    open var bottomConstraint: Constraint?
    
    open weak var navBar:GRNavBar!
    
    open weak var tableView:UITableView!
    
    private func setupTableView () -> UITableView {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            let viewAbove = self.navBar
            if let viewAbove = viewAbove {
                make.top.equalTo(viewAbove.snp.bottom)
            } else {
                make.top.equalTo(self)
            }
                        
            self.bottomConstraint = make.bottom.equalTo(self).constraint
        }
        
        tableView.layer.zPosition = 0;
        return tableView
    }
    
    @discardableResult open func setup(withSuperview superview: UIView, header: String, rightNavBarButtonTitle: String, addNavBar: Bool = true) -> GRViewWithTableView {
        superview.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(superview)
        }
    
        let rightButton = Style.clearButton(with: rightNavBarButtonTitle, superview: nil, fontSize: .small)
        
        if (addNavBar) {
            self.navBar = Style.navBar(withHeader: header, superview: self, leftButton: GRButton(type: .Back), rightButton: rightButton, isBackButton: true, subheadingText: nil)
        }
        
        self.tableView = self.setupTableView()
        
        return self
    }
    
    /**
     Set the data source and the delegate of the table view
     
     - Parameter owner: The view controller which will act as the data source and delegate for the table view
     */
    public func setTableViewDelegateAndDataSource (owner: UIViewController) {
        guard
            let delegate = owner as? UITableViewDelegate,
            let dataSource = owner as? UITableViewDataSource
            else {
                assertionFailure("owner must adhere to UITableViewDelegate and UITableViewDataSource protocols.  Make sure to adopt those protocols on the owner ViewController")
                return
        }
        
        self.tableView.delegate = delegate
        self.tableView.dataSource = dataSource
    }    
}
