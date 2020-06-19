# constrain

[![CI Status](https://img.shields.io/travis/anconaesselmann/constrain.svg?style=flat)](https://travis-ci.org/anconaesselmann/constrain)
[![Version](https://img.shields.io/cocoapods/v/constrain.svg?style=flat)](https://cocoapods.org/pods/constrain)
[![License](https://img.shields.io/cocoapods/l/constrain.svg?style=flat)](https://cocoapods.org/pods/constrain)
[![Platform](https://img.shields.io/cocoapods/p/constrain.svg?style=flat)](https://cocoapods.org/pods/constrain)

## Example

~To run the example project, clone the repo, and run `pod install` from the Example directory first.~ Example project only used for testing so far

## Requirements

## Installation

constrain is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'constrain'
```

## Usage

This library lets you quickly and efficiently set up a number of constraints using intuitive chaining syntax. For example:

```swift
let containerView = UIView()
let newView = UIView()
let centeredView = UIView()
containerView.constainSubview(newView).fillSafely()
centeredView.constrainIn(containerView).center()
```

You can start the chain by typing any of these, depending on what you’re trying to do:
Called on view to be constrained:
 - constrain
 - constrainIn() - invertes the order (called on the child, parent is the argument
 
 Called on superview or VC of superview:
 - constrainSubview()
 - constrainChild() - also handles view controller parent/child relationships, argument must be a VC. Optional argument for if you want the view to be a subview of a different view than the VC's view.
 - constrainSibling()
 - constrainSiblingToBottom()
 - constrainSiblingToTrailing()

Then you chain the constraints you want to make. They parameters default to zero padding and to relevant anchors on the superview, so for example you can just use `view.constrain.top()` if you want to constrain it to the superview’s top with no margin.

There’s also compound ones that handle common sets of constraints, like fillWidth() is leading + trailing, fillHeight() is top + bottom, and fill() is all 4.

There are "safe" versions of top and bottom that use the safe areas, and corresponsing fillSafely and fillHeightSafely. There's also centerSafely.

Notes:
 - All constraints are enabled by default
 - Adding subviews is handled by `constrainSubview()`, `constrainIn()`, `constrainSibling()`, `constrainSiblingToTrailing()`, or `constrainSiblingToBottom()`. If you need to add more constraints at a later time, just call `constrain` subsequently to avoid redoing it, although there's no harm in it.
 - `translatesAutoresizingMaskIntoConstraints` is always set to false
 - Most methods can also be called with View Controllers, but only the `constrainChild()` method handles parent/child UIViewController relationships. Call `remove()` to undo it.
 - Trailing and Bottom constraints invert the input constant so it functions more as padding. Be careful with this if you want to change the constant in the future, as the inversion will not be preserved!

## Author

anconaesselmann, axel@anconaesselmann.com

## License

constrain is available under the MIT license. See the LICENSE file for more info.
