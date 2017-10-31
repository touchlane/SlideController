# SlideController

[![Build Status](https://travis-ci.org/touchlane/SlideController.svg?branch=master)](https://travis-ci.org/touchlane/SlideController)
[![codecov.io](https://codecov.io/gh/touchlane/SlideController/branch/master/graphs/badge.svg)](https://codecov.io/gh/codecov/example-swift/branch/master)
[![Version](https://img.shields.io/cocoapods/v/SlideController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)
[![License](https://img.shields.io/cocoapods/l/SlideController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)
[![Platform](https://img.shields.io/cocoapods/p/SlideController.svg?style=flat)](http://cocoapods.org/pods/ScrollController)

SlideController is replacement for Apple's UIPageControl completely written in Swift using power of generic types.

## Sample Project

There is a sample project in Example directory. To use it run `pod install`.

## Requirements

* iOS 9.0+
* Swift 4.0+

## Installation

ScrollController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlideController'
```

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
