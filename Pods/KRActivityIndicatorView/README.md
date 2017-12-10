[日本語](./README_Ja.md)

# KRActivityIndicatorView

[![Version](https://img.shields.io/cocoapods/v/KRActivityIndicatorView.svg?style=flat)](http://cocoapods.org/pods/KRActivityIndicatorView)
[![License](https://img.shields.io/cocoapods/l/KRActivityIndicatorView.svg?style=flat)](http://cocoapods.org/pods/KRActivityIndicatorView)
[![Platform](https://img.shields.io/cocoapods/p/KRActivityIndicatorView.svg?style=flat)](http://cocoapods.org/pods/KRActivityIndicatorView)
[![Download](https://img.shields.io/cocoapods/dt/KRActivityIndicatorView.svg?style=flat)](http://cocoapods.org/pods/KRActivityIndicatorView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRActivityIndicatorView.svg?style=flat)](https://travis-ci.org/krimpedance/KRActivityIndicatorView)

`KRActivityIndicatorView` is a simple and customizable activity indicator written in Swift.

You can add KRActivityIndicatorView from IB and code.

<img src="./Resources/demo.gif" height=400>

On HUD => https://github.com/krimpedance/KRProgressHUD

## Features
- Round indicator
- Indicator color can be customized

## Requirements
- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## DEMO
To run the example project, clone the repo, and open `KRActivityIndicatorViewDemo.xcodeproj` from the DEMO directory.

or [appetize.io](https://appetize.io/app/v73ez7gvuzzuhxecu4zqv4em0r)

## Installation
KRActivityIndicatorView is available through [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).
To install it, simply add the following line to your Podfile or Cartfile:

```ruby
# CocoaPods
pod "KRActivityIndicatorView"
```

```ruby
# Carthage
github "Krimpedance/KRActivityIndicatorView"
```

## Usage
(see sample Xcode project in /Demo)

Usage is almost same as UIActivityIndicatorView.

#### Showing activity indicator

Show simple KRActivityIndicatorView.

```swift
let activityIndicator = KRActivityIndicatorView()
view.addSubview(activityIndicator)
```

With single color.

```swift
KRActivityIndicatorView(style: .color(.green))
```

With gradation color.

```swift
KRActivityIndicatorView(style: .gradationColor(head: .red, tail: .orange))
```

#### Start and stop animation.

```
activityIndicator.startAnimating()
activityIndicator.stopAnimating()
```

## Customization

#### KRActivityIndicatorViewStyle

* `color(color)` - The fill color of activity indicator is set to `color`.
* `color(head: UIColor, tail: UIColor)` - The fill color of activity indicator is gradated from `head` color to `tail` color.

#### Current available params on IB:
* `headColor` - gradient head color.
* `tailColor` - gradient tail color.
* `isLarge` - Size of KRActivityIndicatorView. Default(off) size is 20x20, Large size is 50x50.
* `animating` - Animation of activity indicator when it's shown
* `hidesWhenStopped` - calls `setHidden` when call `stopAnimating()`

## Contributing to this project
I'm seeking bug reports and feature requests.

## Release Note
- 2.1.1 : Supported from iOS 8.0.
- 2.1.0 : Available at CocoaPods and Carthage with Xcode9 and Swift4.
- 2.0.2 : Fixed bag which don't change `headColor` and 'tailColor'.

## License
KRActivityIndicatorView is available under the MIT license. See the LICENSE file for more info.
