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

