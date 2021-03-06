//
//  GRTabController.swift
//  Graffiti
//
//  Created by Adebayo Ijidakinro on 2/7/20.
//  Copyright © 2020 Dephyned. All rights reserved.
//

import Foundation
import UIKit

open class GRTabController: UIViewController {
        
    /// The view that shows this tab controller's UI elements
    open weak var footer:GRFooterView?
    
    /// The current view being displayed on the screen
    open weak var mainView:UIView?
        
    /// The height of this bar
    static let barHeight:CGFloat = Style.getScreenSize() == .xs ? ( Style.isIPhoneX() ? 75 : 50) : 75
    
    /// The number of buttons displayed on the footer view
    public let numberOfButtons:Int
    
    /// All the view controllers that are controlled by this controller
    open var viewControllers = [String:UIViewController]()
    
    /// The color of the footer buttons when not selected
    private let buttonsBackgroundColor:UIColor
    
    /// The color of the footer buttons when selected
    private let buttonSelectedColor:UIColor
    
    open override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "1", modifierFlags: .command, action: #selector(showNotificationsViewController)),
            UIKeyCommand(input: "2", modifierFlags: .command, action: #selector(showScheduleViewController)),
            UIKeyCommand(input: "3", modifierFlags: .command, action: #selector(showReaderViewController)),
        ]
    }
    
     @objc open func showNotificationsViewController () {
        guard let viewController = self.viewControllers["Notifications"] else { return }
        
        self.highlightButton(key: "Notifications")
        self.setChildViewController(viewController: viewController)
    }
    
    @objc open func showScheduleViewController () {
        guard let viewController = self.viewControllers["Schedule"] else { return }
        
        self.highlightButton(key: "Schedule")
        self.setChildViewController(viewController: viewController)
    }
    
    @objc open func showReaderViewController () {
        guard let viewController = self.viewControllers["Reader"] else { return }
        
        self.highlightButton(key: "Reader")
        self.setChildViewController(viewController: viewController)
    }
    
    /**
     Adds the footer to the current view
     
     - returns: The footer object with all buttons added
     */
    open func addFooter () -> GRFooterView? {
        let footer = GRFooterView(superview: self.view, height: GRTabController.barHeight, numberOfButtons: self.numberOfButtons)
        footer.backgroundColor = self.buttonsBackgroundColor
        return footer
    }
    
    open func addMainView () -> UIView {
        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.footer?.snp.top ?? self.view)
        }
        
        return view
    }
    
    override open func viewDidLoad() {
        self.view.backgroundColor = self.buttonsBackgroundColor
    }
    
    public init(numberOfButtons:Int, buttonsBackgroundColor:UIColor = .white, buttonSelectedColor:UIColor = UIColor.Style.lightGray) {
        self.numberOfButtons = numberOfButtons
        self.buttonsBackgroundColor = buttonsBackgroundColor
        self.buttonSelectedColor = buttonSelectedColor
        super.init(nibName: nil, bundle: nil)
        self.footer = self.addFooter()
        self.mainView = self.addMainView()
        
    }
    
    required public init?(coder: NSCoder) {
        self.numberOfButtons = 3
        self.buttonsBackgroundColor = .white
        self.buttonSelectedColor = UIColor.Style.lightGray
        super.init(coder: coder)
    }
    
    /**
     Adds a button to the footer
     
     - parameters:
        - title: Title of the button to display
        - imageName: The name of the image to show
        - viewControllerToShow: The View Controller to show when pressed
        - addDefaultTargetClosure: If when pressing this button you need it to do something different than the default action of simply showing the view controller in a UINavigationController than set this to false, but make sure that you set the target closure yourself
     */
    open func addFooterButton (title: String, imageName: String, viewControllerToShow: UIViewController, addDefaultTargetClosure: Bool = true) {
        self.viewControllers[title] = viewControllerToShow
        let footerButton = GRFooterView.getFooterButton(title: title, imageName: imageName)
        footerButton.backgroundColor = self.buttonsBackgroundColor
        self.footer?.addButton(button: footerButton, key: title)
        
        if addDefaultTargetClosure {
            footerButton.addTargetClosure { [weak self] (_) in
                guard let self = self else { return }
                self.highlightButton(key: title)
                self.setChildViewController(viewController: viewControllerToShow)
            }
        }
    }
    
    /**
     Set the child view controller, if it's not of type UINavigationController than set it as the root of a UINavigationController object and than set that object as the child
     
     - parameter viewController: The View Controller to set as the child
     */
    open func setChildViewController(viewController: UIViewController) {
        
        // First remove any child viewcontrollers of this tab bar controller because we only want one child view controller at a time
        self.children.forEach { [weak self] (viewController) in
            guard let self = self else { return }
            self.removeChildViewController(viewController)
        }
        
        // Make sure that this view controller to show is not a UINavigationController otherwise the app will crash because it will try to add a UINavigationController to a UINavigationController which is impossible.
        if !(viewController is UINavigationController) {
            let mainNavigationViewController = UINavigationController(rootViewController: viewController);
            mainNavigationViewController.navigationBar.isHidden = true
                                    
            self.addChildViewControllerWithView(mainNavigationViewController, toView: self.mainView)
        } else { // If view controller is a UINavigationController than just add it as a child view controller
//            (viewController as? UINavigationController)?.popToRootViewController(animated: true)
            self.addChildViewControllerWithView(viewController, toView: self.mainView)
        }
    }
    
    /**
     Set whatever button is currently selected to a background of gray so the user knows what screen they're on
     
     - parameter key: The key of the button to set the background of
     */
    open func highlightButton (key: String) {
        self.viewControllers.keys.forEach { [weak self] (key) in
            self?.footer?.getButtonByKey(key: key)?.backgroundColor = self?.buttonsBackgroundColor
        }
        
        self.footer?.getButtonByKey(key: key)?.backgroundColor = self.buttonSelectedColor
    }
    
}
