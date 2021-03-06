# Changelog for SlideController 1.5.1
### Changed
* Updates for Swift 5.0

# Changelog for SlideController 1.5.0
### Fixed
* Improved performance by replacing autolayout with frame-based layout
* Fixed title view jumping while scrolling content

# Changelog for SlideController 1.4.0
### Added
* Updates for Swift 4.2

# Changelog for SlideController 1.3.5
### Fixed
* Reset of `isScrollEnabled` property

# Changelog for SlideController 1.3.4
### Fixed
* Sliding indicator animation when title jumps not animated.

# Changelog for SlideController 1.3.3
### Added
* `shouldAnimateIndicatorOnSelection(index: Int) -> Bool` in `TitleConfigurable` allows to manage animation of sliding indicator

# Changelog for SlideController 1.3.2
### Fixed
* Do not allow multiple `shift` calls at the same time to prevent titleView freeze.

# Changelog for SlideController 1.3.1
### Example changes
* `insertAction` now inserts a page before currently selected page for both vertical and horizontal samples.
* `removeAction` now deletes current page for vertical sample as well as for horizontal.

# Changelog for SlideController 1.3.0
### Added
* New example look 🎉 .
### **Breaking Change**
* ```isCircular``` renamed to ```isCarousel```.
### Fixed
* Select title item after ```insert(object: SlideLifeCycleObjectProvidable, index: Int)```

# Changelog for SlideController 1.2.2
### Fixed
* ```isScrollEnabled``` exposed to public api as intended.
* ```currentIndex``` calculation for not layouted views.

# Changelog for SlideController 1.2.1
### Fixed
* Title item selection follow up. [#35](https://github.com/touchlane/SlideController/issues/35)
* Title view sometimes not responding after app enters foreground.

# Changelog for SlideController 1.2.0
### Added
* `isCircular` setting that enables infinite scroll between pages.
* `TitleViewAlignment` enum extended with `bottom` option.
* Carousel sample added to example project.

### Fixed
* Views unloading on manual `shift(pageIndex:, animated:)` call

# Changelog for SlideController 1.1.1
### Added
* Disabled animation on item selection.

### Fixed
* Sync LifeCycle calls with animation. [#44](https://github.com/touchlane/SlideController/issues/44)

# Changelog for SlideController 1.1.0
### Added
* **Breaking Change** `SlidePageModel` renamed to `SlideLifeCycleObjectBuilder`.
* Callback method `func indicator(position: CGFloat, size: CGFloat, animated: Bool)` in TitleScrollView to implement sliding indicator.
* Sliding indicator HorizontalTitleScrollView sample. 

# Changelog for SlideController 1.0.4
### Fixed
* Transition between tabs performance.

# Changelog for SlideController 1.0.3
### Added
* ``isContentUnloadingEnabled`` setting that allows disable pages unloading.
### Fixed
* ``SlidePageLifeCycle`` calls on ``insert(object:, index:)`` .
* ``SlidePageLifeCycle`` calls on ``shift(pageIndex:, animated:)``.

# Changelog for SlideController 1.0.2
### Added
* Unit tests
### Fixed
* ``SlidePageLifeCycle`` calls on ``removeViewAtIndex(index:)`` 
* ``SlidePageLifeCycle`` calls when appended pages to empty ``SlideController``
* Duplicated ``didStartSliding`` calls

# Changelog for SlideController 1.0.1
### Fixed
* Inappropriate lifecycle calls when ``SlideController`` appears.
* View loading on ``slideController.shift(pageIndex: Int, animated: Bool)``.
* Lifecycle ``didStartSliding`` calls on page transition.
* Layouting ``SlideContentView`` in ``changeContentLayoutAction`` when changing device orientation.
* Crash calculating ``currentIndex`` when ``contentSize`` of a page is 0.

# Changelog for SlideController 1.0.0
### Added
* Vertical ``SlideController`` implementation.
* Smart transition - skipping intermediate pages.
* ``SlideContentView`` lazy loading.
* ``SlideContentView`` unloading.
* ``FeatureManager`` for feature toggling.
* ``ActionsView`` for both vertical and horizontal example.
* Device orientation support.
* ``TitleItemObject`` auto selection when it is out of the screen while sliding.
* Lock ``TitleView`` for scrolling and selection while ``SlideController's`` is sliding.
### Fixed
* ScrollView automatically adjusted ``contentInsets``.

