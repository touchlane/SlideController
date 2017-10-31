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

Then, run the following command:

```$ pod install```

## Manually

# Usage

```swift
import SlideController
```

1) Create content
```swift
let content = [
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>()
        ]
 ```

2) Initialize SlideController
```swift
SlideController<CustomTitleView, CustomTitleItem>(
    pagesContent: content,
    startPageIndex: 0,
    slideDirection: .horizontal
)
```
In the above example:
* ``PageLifeCycleObject`` is any object conforms to ``Initializable, Viewable, SlidePageLifeCycle `` protocols
* ``CustomTitleView`` is subclass of ``TitleScrollView<CustomTitleItem>``
* ``CustomTitleItem`` is subclass of ``UIView`` and conforms to ``Initializable, ItemViewable, Selectable`` protocols

3) Add ``slideController.view`` to view hierarchy

4) Call ``slideController.viewDidAppear()`` and ``slideController.viewDidDisappear()`` in appropriate UIViewController methods:

 ```swift
 override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     controller.viewDidAppear()
 }```
 
 ```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    controller.viewDidDisappear()
}```
   

# Sample Project

There is a sample project in Example directory. To use it run `pod install`.

# Author

Touchlane LLC, tech@touchlane.com

# License

SlideController is available under the MIT license. See the LICENSE file for more info.
