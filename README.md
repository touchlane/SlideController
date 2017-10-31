[![Build Status](https://travis-ci.org/touchlane/SlideController.svg?branch=master)](https://travis-ci.org/touchlane/SlideController)
[![codecov.io](https://codecov.io/gh/touchlane/SlideController/branch/master/graphs/badge.svg)](https://codecov.io/gh/codecov/example-swift/branch/master)
[![Version](https://img.shields.io/cocoapods/v/ScrollController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)
[![License](https://img.shields.io/cocoapods/l/ScrollController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)
[![Platform](https://img.shields.io/cocoapods/p/ScrollController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)

SlideController is simple and flexible MVP-based UI component completely written in Swift. It is nice alternative for UIPageViewController built using power of generic types.

# Features

# Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

# Installation

## CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```$ gem install cocoapods```

To integrate SlideController into your Xcode project using CocoaPods, specify it in your ```Podfile```:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SlideController'
end
```

## Sample Project

There is a sample project in Example directory. To use it run `pod install`.

## Usage

First you have to initialize SlideController with required types and SlideDirection (``.horizontal`` or ``.vertical``)

```swift
SlideController<HorizontalTitleScrollView, HorizontalTitleItem>(
    pagesContent: pagesContent,
    startPageIndex: 0,
    slideDirection: SlideDirection.horizontal
)
```

* ``HorizontalTitleScrollView`` type for title view. Subclass of ``TitleScrollView<HorizontalTitleItem>``;
* ``HorizontalTitleItem`` item in title view. UIView that conforms to ``Initializable, ItemViewable, Selectable`` protocols;
* ``pagesContent`` is an array of ``SlidePageModel`` which represents pages that SlideController will display;

``SlidePageModel<T: SlideLifeCycleObject>`` holds an object responsible for page life cycle. Here you can react to changes for the page.

Add ``slideController.view`` on your ViewController with ``view.addSubview()`` method.

For SlideController to work you have to call ``slideController.viewDidAppear()`` and ``slideController.viewDidDisappear()`` in appropriate UIViewController methods.

## Author

Touchlane LLC, tech@touchlane.com

## License

SlideController is available under the MIT license. See the LICENSE file for more info.
