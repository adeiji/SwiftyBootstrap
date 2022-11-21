# SwiftyBootstrap

[![CI Status](https://img.shields.io/travis/adeiji/SwiftyBootstrap.svg?style=flat)](https://travis-ci.org/adeiji/SwiftyBootstrap)
[![Version](https://img.shields.io/cocoapods/v/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)
[![License](https://img.shields.io/cocoapods/l/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 12.0+ / Mac OS X 10.12+ / tvOS 10.0+
Xcode 10.0+
Swift 4.0+

## Installation

SwiftyBootstrap is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyBootstrap'
```

## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

# Usage

Below is a simple example of adding two buttons to the screen that are full screen on iPhone portrait mode and half screen on iPhone landscape or iPad.

```swift
let card = GRBootstrapElement()
        
card.addRow(columns: [
    Column(UIButton().withAttributes(closure: { view in
        let button = view as? UIButton
        button?.setTitle("Button 1", for: .normal)
    })
    .cardSet(),
           xsColSpan: .Twelve).forSize(.sm, .Six),
    Column(UIButton().withAttributes(closure: { view in
        let button = view as? UIButton
        button?.setTitle("Button 2", for: .normal)
    })
    .cardSet(),
           xsColSpan: .Twelve).forSize(.sm, .Six),
], anchorToBottom: true)

card.addToSuperview(superview: self.view)
```

## Author

adeiji, adeiji@yahoo.com

## License

SwiftyBootstrap is available under the MIT license. See the LICENSE file for more info.
