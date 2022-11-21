# SwiftyBootstrap

[![Version](https://img.shields.io/cocoapods/v/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)
[![License](https://img.shields.io/cocoapods/l/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyBootstrap.svg?style=flat)](https://cocoapods.org/pods/SwiftyBootstrap)

SwiftyBootstrap is a Framework designed to help you build UI's programmatically more quickly. It's designed after Twitter Bootstrap, mainly the use of columns to specify how a UI element will be laid out across various device sizes.  

Now you can quickly specify how you want your layout to show on different devices in only a few lines of code.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Documentation

To see the full documentation click [here](https://swiftybootstrap.netlify.app/documentation/swiftybootstrap).

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

Below is a simple example of adding two buttons to the screen.

```swift
let card = GRBootstrapElement()
                
card.addRow(columns: [
    Column(UIButton().withAttributes(closure: { view in
        let button = view as? UIButton
        button?.setTitle("Button 1", for: .normal)
    })
    .cardSet(),
    xsColSpan: .Twelve) // Full screen on xtra small screen (iPhone Portrait, split screen smaller section)
    .forSize(.sm, .Six) // Half screen on small screen (iPhone Landscape, split screen half of screen)
    .forSize(.md, .Three), // Quarter of the screen on iPad portrait
    Column(UIButton().withAttributes(closure: { view in
        let button = view as? UIButton
        button?.setTitle("Button 2", for: .normal)
    })
    .cardSet(),
    xsColSpan: .Twelve), // Full screen on xtra small and since no other size classes are specified, full screen on all sizes
], anchorToBottom: true)

card.addToSuperview(superview: self.view)
```

# Example of How It Looks
In this example we used size classes like above to specify how the layout would change as the size of the device changes.

https://user-images.githubusercontent.com/5272761/203091299-292de878-ac3c-41ed-bb00-206b2030a2a6.MP4

## Author

adeiji, adeiji@yahoo.com

## License

SwiftyBootstrap is available under the MIT license. See the LICENSE file for more info.
