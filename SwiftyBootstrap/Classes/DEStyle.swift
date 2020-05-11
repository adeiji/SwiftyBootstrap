//
//  DEStyle.swift
//  Graffiti
//
//  Created by adeiji on 4/5/18.
//  Copyright © 2018 Dephyned. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class GRCurrentDevice: UIViewController {
    
    public static let shared = GRCurrentDevice()
    public var size:Style.DeviceSizes = Style.getScreenSize()
    
}

public enum FontBook:String {
//    case logo = "Gill Sans"
    case header = "Avenir-Medium"
    case all = "Avenir"
    case allBold = "Avenir-Heavy"
    case allLight = "Avenir-Light"
    
    public func of(size: FontSizes) -> UIFont {
        return UIFont(name: self.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
}

public enum FontSizes:CGFloat {
    case verySmall = 11.0
    case small = 15.0
    case medium = 20.0
    case large = 25.0
    case header = 19.0
    case logo = 38.0
}

public enum Sizes:CGFloat {
    case smallMargin = 10.0
    case MinimalLargeMargin = 15.0
    case smallButton = 40.0
    case LargeButton = 70.0
    case OrangeRoundedButton = 45
    case ButtonWithText = 120.0
}

public enum FontNames:String {
//    case logo = "Gill Sans"
    case header = "Avenir-Medium"
    case all = "Avenir"
    case allBold = "Avenir-Heavy"
    case allLight = "Avenir-Light"    
}

enum CellType:String {
    case text = "text"
    case transition = "transition"
    case share = "share"
}

struct SnapConstraint {
    var object:UIView!;
    var type:ConstraintType!
    var toType:ConstraintType!
    var offset:CGFloat = 0;
}

enum ConstraintType {
    case left
    case right
    case bottom
    case top
    case width
    case height
}

enum AnimationType {
    case HorizontalExpansion
    case VerticalExpansion
}

class Animation : UIView {
    
    var color:UIColor?
    var size:CGSize?
    let animation:AnimationType
    
    init(animation:AnimationType) {
        self.animation = animation
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show () {}
    
    func hide () {}
}

open class Style {

    // The sizes class will handle the sizing of the device/interface
    public enum DeviceSizes {
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
    
    /** Get what the current screen size is, ex large, small, very large etc.  Currently on returns small or large */
    open class func getScreenSize () -> DeviceSizes {
        let width = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ?? UIApplication.shared.windows.first?.bounds.width ?? UIScreen.main.bounds.width
        
        switch width {
        case let x where x <= 450: // iPhone Width or the slim view of the iPad
            return .xs
        case let x where x < 768: // less than iPad full width so half of screen in landscape
            return .sm
        case let x where x > 768 && x < 1024: // It's the portrait of an iPad
            return .md
        case let x where x >= 1024 && x < 1366: // It's either a normal iPad landscape, or iPad Pro 12.9inch portrait
            return .lg
        default: // iPad Pro 12.9inch landscape
            return .xl
        }
    }

    /// If in landscape mode we need the width to be whatever the highest dimension is since unfortunately sometimes the height and
    /// the width values are switched.  So for example, in landscape if the height is reading as 1134 and the width 865, we know that we
    /// need to use the height value since in landscape width is always greater than height
    /// This works vice versa for portrait
    open class func getCorrectWidth () -> CGFloat {
                        
        let width = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ??  UIApplication.shared.windows.first?.bounds.width ?? UIScreen.main.bounds.width
        
        return width
    }
    
    /// Returns a random color that is within our Pinterest color scheme
    open class func getPinterestColor () -> UIColor {
        
        let pinterestColors = [
            UIColor.Pinterest.aquaBlue,
            UIColor.Pinterest.darkerPink,
            UIColor.Pinterest.lightPink,
            UIColor.Pinterest.lightYellow,
            UIColor.Pinterest.oceanBlue
        ]
        
        let randomInt = Int.random(in: 0..<5)
        
        return pinterestColors[randomInt]
        
    }
    
    /// Show any image really fast on the screen that indicates that an action was just taken successfully
    open class func showActionBadge (view: UIView?, imageNamed: String) {
        guard let view = view else { return }
        let imageView = UIImageView(image: UIImage(named: imageNamed))
        view.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.center.equalTo(view)
            make.width.equalTo(300)
            make.height.equalTo(300)
        })
        
        UIView.animate(withDuration: 1.0, animations: {
            imageView.alpha = 0.0
        }, completion: { (_) in
            imageView.removeFromSuperview()
        })
    }
    
    open class func showAndGetPostingIndicator () -> UIView? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        guard let postingView = UINib(nibName: "PostingIndicatorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView else { return nil }
        window.addSubview(postingView)
        postingView.snp.makeConstraints { (make) in
            make.left.equalTo(window)
            make.top.equalTo(window).offset(Sizes.smallMargin.rawValue * 2.0)
            make.right.equalTo(window)
            make.height.equalTo(15)
        }
        
        return postingView
    }
    
    open class func addButton (belowView view: UIView, withSuperview superview:UIView, height:CGFloat, width:CGFloat, backgroundColor: UIColor, textColor: UIColor, title: String, cornerRadius: CGFloat, fontSize: FontSizes) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        superview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(Sizes.smallMargin.rawValue)
            make.centerX.equalTo(view)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont(name: FontNames.all.rawValue, size: fontSize.rawValue)
        button.showsTouchWhenHighlighted = true
        return button
    }
    
    @discardableResult open class func viewStack (withSuperview superview:UIView, align: NSTextAlignment, views: [UIView], eachViewHeight:Int? = nil) -> UIView {
        let stackView = UIView()
        superview.addSubview(stackView)
        
        var counter = 0;
        for view in views {
            if let view = view as? UILabel {
                view.textAlignment = align
            }
            
            stackView.addSubview(view)
            view.snp.makeConstraints { (make) in
                if view == views.first {
                    make.top.equalTo(stackView)
                } else {
                    make.top.equalTo(views[counter-1].snp.bottom)
                }
                make.left.equalTo(stackView)
                make.right.equalTo(stackView)
                if let height = eachViewHeight {
                    make.height.equalTo(height)
                }
                if view == views.last {
                    make.bottom.equalTo(stackView)
                }
            }
            counter = counter + 1
        }
        
        return stackView
    }
    
    open class func tableView (withSuperview superview:UIView, viewAbove:UIView!, offset: CGFloat, viewBelow:UIView? = nil) -> UITableView {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        superview.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            if viewAbove != nil {
                make.top.equalTo(viewAbove.snp.bottom).offset(offset)
            } else {
                make.top.equalTo(superview)
            }
                        
            make.bottom.equalTo(viewBelow?.snp.top ?? superview)
        }
        
        tableView.layer.zPosition = 0;
        return tableView
    }
    
    open class func tableViewWithBottomConstraint (withSuperview superview:UIView, viewAbove:UIView!, offset: CGFloat, viewBelow:UIView? = nil) -> (tableView: UITableView, bottomConstraint: Constraint?) {
        let tableView = UITableView()
        var constraint:Constraint?
        
        superview.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            if viewAbove != nil {
                make.top.equalTo(viewAbove.snp.bottom).offset(offset)
            } else {
                make.top.equalTo(superview)
            }
                        
            constraint = make.bottom.equalTo(viewBelow?.snp.top ?? superview).constraint
        }
        
        tableView.layer.zPosition = 0;
        return (tableView: tableView, bottomConstraint: constraint)
    }
    
    open class func leftBottomCornerButton (withSuperview superview:UIView, type: GRButtonType) -> GRButton {
        let button = GRButton(type: type)
        superview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(10)
            make.bottom.equalTo(superview).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        button.layer.zPosition = 1
        return button
    }
    
    open class func rightBottomCornerButton (withSuperview superview:UIView, type: GRButtonType) -> GRButton {
        let button = GRButton(type: type)
        superview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalTo(superview).offset(-10)
            make.bottom.equalTo(superview).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        button.layer.zPosition = 1
        return button
    }
    
    open class func progressView (withSuperview superview: UIView) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.tintColor = .white
        progressView.trackTintColor = .green
        superview.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(Sizes.smallMargin.rawValue)
            make.right.equalTo(superview).offset(-Sizes.smallMargin.rawValue)
            make.bottom.equalTo(superview).offset(-Sizes.smallMargin.rawValue)
            make.height.equalTo(2)
        }
        
        return progressView
    }
    
    open class func finishedTaskView (withSuperview superview: UIView, withTitle title: String) -> (view: UIView, button: UIButton) {
        let progressViewContainer = UIView()
        superview.addSubview(progressViewContainer)
        progressViewContainer.backgroundColor = .black
        progressViewContainer.layer.opacity = 0.85
        progressViewContainer.snp.makeConstraints { (make) in
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.bottom.equalTo(superview)
            make.height.equalTo(50)
        }
        
        let label = Style.label(withText: title, fontName: .all, size: .small, superview: progressViewContainer, color: .white)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(progressViewContainer).offset(Sizes.smallMargin.rawValue)
            make.right.equalTo(progressViewContainer).offset(-Sizes.smallMargin.rawValue)
            make.centerY.equalTo(progressViewContainer)
        }
        
        let button = GRButton(type: .Okay)
        progressViewContainer.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalTo(progressViewContainer).offset(-Sizes.smallMargin.rawValue)
            make.centerY.equalTo(progressViewContainer)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        return (view: progressViewContainer, button: button)
    }
    
    open class func isIPhoneX () -> Bool {
        if(UIDevice.current.userInterfaceIdiom == .phone) {
            switch (UIScreen.main.nativeBounds.size.height) {
            case 1136:
                return false;
            case 1334:
                return false;
            case 1920, 2208:
                return false;
            case 2436:
                return true;
            case 2688:
                return true;
            case 1792:
                return true;
            default:
                return false;
            }
        }
        
        return false;
    }
    
    /**
     * - Description Adds a navBar at the top of the superview with all the appropriate constraints
     * - Parameter header Set this to nil if you want to use the default text, otherwise give it a specific header text
     * - Parameter superview The view which will be the superview of the navBar
     * - Parameter leftButton The button which will show on the left side of the navBar
     * - Parameter rightButton The button which will show on the right side of the navBar
     * - Returns a UIView
     */
    open class func navBar (withHeader header: String!,
                       superview: UIView,
                       leftButton: UIButton!,
                       rightButton: UIButton!,
                       addRightButton:UIButton? = nil,
                       addSecondRightButton:UIButton? = nil,
                       addLeftButton:UIButton? = nil,
                       isBackButton: Bool = false,
                       subheadingText:String? = nil,
                       height:CGFloat? = nil) -> GRNavBar {
        let navBar = GRNavBar()
        navBar.backgroundColor = UIColor.white.dark(.black)
        navBar.layer.borderWidth = 0
        navBar.layer.borderColor = UIColor.Style.blueGrey.cgColor
        superview.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.left.equalTo(superview)
            make.top.equalTo(superview).offset(20)
            make.right.equalTo(superview)
            
            if isIPhoneX() {
                make.height.equalTo(height != nil ? (height! - 20 + 15) :  70)
            } else {
                make.height.equalTo(height != nil ? (height! - 20) : 55)
            }
        }
        
        let headerLabel = UILabel()
        navBar.addSubview(headerLabel)
        if header != nil {
            headerLabel.text = header;
        } else {
            headerLabel.text = "GRAFFITI"
        }
        
        headerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(navBar)
            if isIPhoneX() {
                make.centerY.equalTo(navBar).offset(20)
            } else {
                make.centerY.equalTo(navBar)
            }
            
            make.left.equalTo(superview).offset(40)
            make.right.equalTo(superview).offset(-40)
        }
        
        headerLabel.numberOfLines = 1
        headerLabel.textAlignment = .center
        navBar.header = headerLabel
        
        var myRightButton = rightButton
        if myRightButton == nil {
            myRightButton = UIButton()
        }
        navBar.addSubview(myRightButton!)
        
        if let rightButton = rightButton as? GRButton {
            rightButton.snp.makeConstraints({ (make) in
                make.right.equalTo(navBar)
                make.centerY.equalTo(headerLabel)
                make.width.equalTo(60)
                make.height.equalTo(60)
            })
        } else {
            myRightButton!.snp.makeConstraints({ (make) in
                make.right.equalTo(navBar).offset(-Sizes.smallMargin.rawValue)
                make.centerY.equalTo(headerLabel)
                make.width.equalTo(65)
                make.height.equalTo(50)
            })
        }
        
        if let addRightButton = addRightButton {
            navBar.addSubview(addRightButton)
            addRightButton.snp.makeConstraints({ (make) in
                make.right.equalTo(rightButton.snp.left).offset(15)
                make.centerY.equalTo(headerLabel)
                make.width.equalTo(65)
                make.height.equalTo(65)
            })
            
            navBar.secondRightButton = addRightButton
            
            if let secondRightButton = addSecondRightButton {
                navBar.addSubview(secondRightButton)
                secondRightButton.snp.makeConstraints({ (make) in
                    make.right.equalTo(addRightButton.snp.left).offset(25)
                    make.centerY.equalTo(headerLabel)
                    make.width.equalTo(65)
                    make.height.equalTo(65)
                })
                
                navBar.thirdRightButton = addSecondRightButton
            }            
        }
        
        var myLeftButton = leftButton
        if myLeftButton == nil {
            myLeftButton = UIButton()
        }
        
        navBar.addSubview(myLeftButton!)
        myLeftButton!.snp.makeConstraints({ (make) in
            make.left.equalTo(navBar)
            make.centerY.equalTo(headerLabel)
            make.width.equalTo(45)
            make.height.equalTo(50)
        })
        
        navBar.leftButton = myLeftButton
        
        if isBackButton {
            navBar.backButton = myLeftButton
        }
        
        if let addLeftButton = addLeftButton {
            navBar.addSubview(addLeftButton)
            addLeftButton.snp.makeConstraints({ (make) in
                make.left.equalTo(myLeftButton!.snp.right).offset(-Sizes.smallMargin.rawValue / 2.0)
                make.centerY.equalTo(headerLabel)
                make.width.equalTo(65)
                make.height.equalTo(50)
            })
            
            navBar.secondLeftButton = addLeftButton
        }
        
        let subheading = UILabel()
        navBar.addSubview(subheading)
        subheading.font = UIFont.systemFont(ofSize: FontSizes.verySmall.rawValue)
        subheading.snp.makeConstraints { (make) in
            make.centerX.equalTo(navBar)
            make.top.equalTo(headerLabel.snp.bottom).offset(-3)
            make.width.equalTo(200)
        }
        subheading.numberOfLines = 1
        subheading.textAlignment = .center
        navBar.subheading = subheading
        subheading.isHidden = true
        
        navBar.rightButton = myRightButton
        
        headerLabel.textColor = UIColor.Style.navBarText
        headerLabel.font = UIFont(name: FontNames.header.rawValue, size: FontSizes.header.rawValue)
        
        return navBar;
    }
    
    /**
     
     Creates a UIImageView object, and also add the constraints, if you want to not use these constraints, than make sure that you set useDefaultConstraints to false.  The default constraints for the image are height and width of whatever you set and a left constant of 10 from it's superview's left side with a centerY equal to it's superview
     
     - parameters:
        - superview: UIView The superview of the view.  UIImageView will be added as a subview of the superview
        - isRound: CGFloat! Boolean value indicating whether you want the UIImageView to be round
        - width: CGFloat! The width of the image view
        - height: CGFloat! The height of the image view
        - useDefaultConstraints: Optional Bool Indicates whether you want to use the default constraints or not
     
     - returns:
        UIImageView - An instance of UIImageView added as a subview to the given superview with constraints added if desired
     */
    open class func imageView (withSuperview superview: UIView?, isRound: Bool, width: CGFloat!, height: CGFloat!, useDefaultConstraints:Bool = true) -> UIImageView {
        let imageView = UIImageView()
        
        if let superview = superview {
            superview.addSubview(imageView)
            if useDefaultConstraints {
                imageView.snp.makeConstraints { (make) in
                    make.left.equalTo(superview).offset(Sizes.MinimalLargeMargin.rawValue)
                    make.top.equalTo(superview).offset(Sizes.MinimalLargeMargin.rawValue)
                    if width != nil {
                        make.width.equalTo(width)
                    } else {
                        make.width.equalTo(superview)
                    }
                    if height != nil {
                        make.height.equalTo(height)
                    } else {
                        make.height.equalTo(imageView.snp.height)
                    }
                }
            }
        }
        
        if isRound {
            imageView.layer.cornerRadius = width / 2
        }

        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }
    
    open class func userView (withSuperview superview: UIView, username: String, location: String?, profileImageUrl: String!, profileImage: UIImage!, viewLeft:UIView? = nil, viewRight:UIView? = nil) -> TagHeaderView {
        let userView = TagHeaderView()
        superview.addSubview(userView)
        userView.snp.makeConstraints { (make) in
            make.left.equalTo(viewLeft?.snp.right ?? superview)
            make.right.equalTo(viewRight?.snp.left ?? superview)
            make.top.equalTo(superview)
        }
        
        let imageView = Style.imageView(withSuperview: userView, isRound: true, width: 40, height: 40)
        if profileImage != nil {
            imageView.image = profileImage
        }
        
        if profileImage == nil && (profileImageUrl == nil || profileImageUrl == "") {
            imageView.backgroundColor = .gray
        }
        
        let usernameLabel = Style.label(withText: username, fontName: .allBold , size: .small, superview: userView, color: .black)
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(Sizes.smallMargin.rawValue)
            make.left.equalTo(imageView)
            make.right.equalTo(userView)
        }
        
        let addressLabel = Style.label(withText: location ?? "No Location", fontName: .all, size: .small, superview: userView, color: .black)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView)
            make.top.equalTo(usernameLabel.snp.bottom).offset(2)
            make.right.equalTo(usernameLabel)
            make.bottom.equalTo(userView)
            
        }
        
        addressLabel.numberOfLines = 0
        userView.mainLabel = usernameLabel
        userView.descriptorLabel = addressLabel
        userView.imageView = imageView
        
        return userView
    }
    
    /**
     Gets a label with no constraints added, but if a superview is provided it will be added to the superview
     */
    open class func label (withText: String, fontName: FontNames = .all, size:FontSizes = .small, superview: UIView!, color: UIColor, numberOfLines:Int = 0, textAlignment: NSTextAlignment = .left, backgroundColor: UIColor? = nil) -> UILabel {
        let font = UIFont.init(name: fontName.rawValue, size: size.rawValue)
        let label = UILabel()
        label.text = withText
        label.font = font
        label.textColor = color
        label.numberOfLines = numberOfLines
        if superview != nil {
            superview.addSubview(label)
        }
        if let backgroundColor = backgroundColor {
            label.backgroundColor = backgroundColor
        }
        label.textAlignment = textAlignment
                
        return label
    }
    
    open class func wideTextField (withPlaceholder: String, superview: UIView?, color: UIColor, autocorrection: UITextAutocorrectionType = UITextAutocorrectionType.no) -> UITextField {
        let font = UIFont.init(name: FontNames.all.rawValue, size: FontSizes.small.rawValue)
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: withPlaceholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: color])
        textField.textColor = color
        textField.autocorrectionType = autocorrection
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        textField.font = font
        if let superview = superview {
          superview.addSubview(textField)
        }
        return textField
    }
    
    open class func clearButton (with title: String, superview: UIView!, fontSize: FontSizes = .small, color: UIColor = UIColor.white, font: FontNames? = .all, borderWidth:CGFloat? = nil, borderColor:UIColor? = nil, backgroundColor:UIColor? = nil, cornerRadius:CGFloat = 0 ) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.init(name: FontNames.all.rawValue, size: fontSize.rawValue)
        if let font = font {
            button.titleLabel?.font = UIFont.init(name: font.rawValue, size: fontSize.rawValue)
        }
        button.setTitle(title, for: .normal)
        if superview != nil {
            superview.addSubview(button)
        }
        button.backgroundColor = .clear
        button.setTitleColor(color, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.layer.cornerRadius = cornerRadius
        
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        
        if let borderWidth = borderWidth {
            button.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
        }
        
        return button;
    }
    
    open class func largeButton (with title: String, superview: UIView? = nil, backgroundColor:UIColor? = nil, borderColor:UIColor? = nil, fontColor:UIColor? = nil, imageName:String? = nil) -> UIButton {
                        
        let button = UIButton()
        
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
            return button
        }
        
        button.titleLabel?.font = UIFont.init(name: FontNames.all.rawValue, size: FontSizes.small.rawValue)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        
        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 0.5
        }
        
        if let fontColor = fontColor {
            button.setTitleColor(fontColor, for: .normal)
        }
        
        if let superview = superview {
            superview.addSubview(button)
        }
        return button;
    }
}

// Enable the ability to use a closure for the UIButton target
public typealias UIButtonTargetClosure = (UIButton) -> ()

public extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else {  return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}

public class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
    
}

public class TagHeaderView: UIView {
    weak var mainLabel:UILabel!
    weak var imageView:UIImageView!
    weak var descriptorLabel:UILabel!
}
