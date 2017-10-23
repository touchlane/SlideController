//
//  ScrollController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

public protocol SlidePageLifeCycle: class {
    func didAppear()
    func didDissapear()
    func viewDidLoad()
    func didStartSliding()
    func didCancelSliding()
    var isKeyboardResponsive: Bool { get }
}

public protocol Viewable: class {
    var view: UIView { get }
}

public protocol ItemViewable: class {
    associatedtype Item: UIView
    var view: Item { get }
}

public protocol Initializable: class {
    init()
}

public protocol ViewSlidable: class {
    associatedtype View: UIView
    func appendViews(views: [View])
    func insertView(view: View, index: Int)
    func removeViewAtIndex(index: Int)
    var firstLayoutAction: (() -> ())? { get set }
    var isLayouted: Bool { get }
}

public protocol ControllerSlidable: class {
    func shift(pageIndex: Int, animated: Bool)
    func showNext(animated: Bool)
    func viewDidAppear()
    func viewDidDisappear()
    func insert(object : SlideLifeCycleObjectProvidable, index : Int)
    func append(object : [SlideLifeCycleObjectProvidable])
    func removeAtIndex(index : Int)
}

public protocol Selectable: class {
    var isSelected: Bool { get set }
    var didSelectAction: ((Int) -> ())? { get set }
    var index: Int { get set }
}

public enum SlideDirection {
    case vertical
    case horizontal
}

public enum TitleViewAlignment {
    case top
    case left
    case right
}

public enum TitleViewPosition {
    case beside
    case above
}

public typealias TitleItemObject = Selectable & ItemViewable
public typealias TitleItemControllableObject = ItemViewable & Initializable & Selectable
public typealias SlideLifeCycleObject = SlidePageLifeCycle & Viewable & Initializable

public class SlideController<T, N>: NSObject, UIScrollViewDelegate, ControllerSlidable, Viewable where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable, N: TitleItemControllableObject, N: UIView, N.Item == T.View {
    private let containerView = SlideView<T>()
    private var titleSlidableController: TitleSlidableController<T, N>!
    private var slideDirection: SlideDirection!
    private var contentSlidableController: SlideContentController!
    private var currentIndex = 0
    private var lastContentOffset: CGFloat = 0
    private var didFinishForceSlide: (() -> ())?
    private var isForcedToSlide = false
    private var isOnScreen = false
    private var scrollInProgress = false
    
    ///Returns title view instanse of specified type
    public var titleView: T {
        return titleSlidableController.titleView
    }
    
    ///Returns model for access to current LifeCycle object
    public var currentModel: SlideLifeCycleObjectProvidable? {
        if isIndexValid(index: currentIndex) {
            return content[currentIndex]
        }
        return nil
    }
    
    ///Array of specified models
    public fileprivate(set) var content = [SlideLifeCycleObjectProvidable]()

    //TODO: Refactoring. we had to add the flag to prevent crash when the current page is being removed
    fileprivate var shouldRemoveContentAfterAnimation: Bool = false
    fileprivate var indexToRemove: Int?

    private lazy var firstLayoutTitleAction: () -> () = { [weak self] in
        guard let `self` = self else { return }
        self.titleSlidableController.jump(index: self.currentIndex, animated: false)
    }
    
    private lazy var firstLayoutContentAction: () -> () = { [weak self] in
        guard let `self` = self else { return }
        self.contentSlidableController.contentSize = self.calculateContentPageSize(direction: self.slideDirection, titleViewAlignment: self.titleSlidableController.titleView.alignment, titleViewPosition: self.titleSlidableController.titleView.position, titleSize: self.titleSlidableController.titleView.titleSize)
        self.contentSlidableController.slideContentView.delegate = self
        self.shift(pageIndex: self.currentIndex, animated: false)
    }
    
    func didSelectTitleItem(index: Int, completion: @escaping () -> ()) {
        loadViewIfNeeded(pageIndex: index)
        isForcedToSlide = true
        shift(pageIndex: index)
        didFinishForceSlide = completion
    }
    
    private lazy var didSelectItemAction: (Int, (() -> ())?) -> () = { [weak self] (index, completion) in
        guard let `self` = self else { return }
        self.loadViewIfNeeded(pageIndex: index)
        self.isForcedToSlide = true
        self.shift(pageIndex: index)
        self.didFinishForceSlide = completion
    }

    public init(pagesContent : [SlideLifeCycleObjectProvidable], startPageIndex: Int = 0, slideDirection : SlideDirection) {
        super.init()
        content = pagesContent
        self.slideDirection = slideDirection
        titleSlidableController = TitleSlidableController(pagesCount: content.count, slideDirection: slideDirection)
        currentIndex = startPageIndex
        contentSlidableController = SlideContentController(pagesCount: content.count, slideDirection: slideDirection)
        titleSlidableController.didSelectItemAction = didSelectItemAction
        loadView(pageIndex: currentIndex)
        containerView.contentView = contentSlidableController.slideContentView
        containerView.titleView = titleSlidableController.titleView
        titleSlidableController.titleView.firstLayoutAction = firstLayoutTitleAction
        contentSlidableController.slideContentView.firstLayoutAction = firstLayoutContentAction
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            contentSlidableController.slideContentView.isScrollEnabled = isScrollEnabled
        }
    }

    //MARK: - ControllerSlidable_Implementation
    
    public func append(object objects : [SlideLifeCycleObjectProvidable]) {
        if objects.count > 0 {
            content.append(contentsOf: objects)
            contentSlidableController.append(pagesCount: objects.count)
            titleSlidableController.append(pagesCount: objects.count)
            if contentSlidableController.slideContentView.isLayouted {
                contentSlidableController.slideContentView.layoutIfNeeded()
            }
            if titleSlidableController.titleView.isLayouted {
                titleSlidableController.titleView.layoutIfNeeded()
            }
            loadView(pageIndex: currentIndex)
        }
    }

    public func insert(object: SlideLifeCycleObjectProvidable, index: Int) {
        guard index < content.count else {
            return
        }
        content.insert(object, at: index)
        contentSlidableController.insert(index: index)
        titleSlidableController.insert(index: index)
        if contentSlidableController.slideContentView.isLayouted {
           contentSlidableController.slideContentView.layoutIfNeeded()
        }
        if titleSlidableController.titleView.isLayouted {
            titleSlidableController.titleView.layoutIfNeeded()
        }
        if index <= currentIndex {
            // FIXME: workaround to fix life cycle calls  
            contentSlidableController.slideContentView.delegate = nil
            shift(pageIndex: currentIndex + 1, animated: false)
            currentIndex = currentIndex + 1
            titleSlidableController.jump(index: currentIndex, animated: false)
            contentSlidableController.slideContentView.delegate = self
            loadViewIfNeeded(pageIndex: index)
        } else {
            loadView(pageIndex: currentIndex)
        }
    }
    
    public func removeAtIndex(index: Int) {
        guard index < content.count else { return }

        //TODO: Refactoring. we had to add the flag to prevent crash when the current page is being removed
        shouldRemoveContentAfterAnimation = index == currentIndex
        if !shouldRemoveContentAfterAnimation {
            content.remove(at: index)
            contentSlidableController.removeAtIndex(index: index)
            titleSlidableController.removeAtIndex(index: index)
        } else {
            indexToRemove = index
        }
        if index < currentIndex {
            shift(pageIndex: currentIndex - 1, animated: false)
        } else if index == currentIndex {
            if currentIndex < content.count - (shouldRemoveContentAfterAnimation ? 1: 0) {

                removeContentIfNeeded()
                titleSlidableController.jump(index: currentIndex, animated: false)
            } else {
                shift(pageIndex: currentIndex - 1, animated: true)
            }
        }
        loadView(pageIndex: currentIndex)
    }
    
    public func shift(pageIndex: Int, animated: Bool = true) {
        if !self.contentSlidableController.slideContentView.isLayouted {
            currentIndex = pageIndex
            loadView(pageIndex: currentIndex)
        } else {
            contentSlidableController.scrollToPage(index: pageIndex, animated: animated)
            if slideDirection == SlideDirection.horizontal {
                lastContentOffset = contentSlidableController.slideContentView.contentOffset.x
            } else {
                lastContentOffset = contentSlidableController.slideContentView.contentOffset.y
            }
        }
    }
    
    public func showNext(animated: Bool = true) {
        var page = currentIndex + 1
        var animated = animated
        if page >= content.count {
            page = 0
            animated = false
        }
        shift(pageIndex: page, animated: animated)
    }
    
    public func viewDidAppear() {
        isOnScreen = true
        if isIndexValid(index: currentIndex) {
            content[currentIndex].lifeCycleObject.didAppear()
        }
    }
    
    public func viewDidDisappear() {
        isOnScreen = false
        if isIndexValid(index: currentIndex) {
            content[currentIndex].lifeCycleObject.didDissapear()
        }
    }
    
    // MARK: - UIScrollViewDelegateImplementation
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollInProgress {
            if content.indices.contains(currentIndex) {
                content[currentIndex].lifeCycleObject.didStartSliding()
            }
            scrollInProgress = true
        }
        let pageSize = contentSlidableController.contentSize
        var actualContentOffset: CGFloat = 0
        if slideDirection == SlideDirection.horizontal {
            actualContentOffset = scrollView.contentOffset.x
        } else {
            actualContentOffset = scrollView.contentOffset.y
        }
        let actualIndex = Int(actualContentOffset / pageSize)
        if actualContentOffset.truncatingRemainder(dividingBy: pageSize) == 0.0 {
            let nextIndex = actualIndex
            if nextIndex != currentIndex {
                loadView(pageIndex: nextIndex)
                titleSlidableController.jump(index: nextIndex, animated: false)
            } else {
                content[currentIndex].lifeCycleObject.didCancelSliding()
            }

            removeContentIfNeeded()

            scrollInProgress = false
        } else {
            let offset = actualContentOffset - lastContentOffset
            var startIndex: Int
            var destinationIndex: Int
            if  offset < 0 {
                startIndex = actualIndex + 1
                destinationIndex = startIndex - 1
            } else {
                startIndex = actualIndex
                destinationIndex = startIndex + 1
            }
            shiftKeyboardIfNeeded(offset: -offset)
            if !isForcedToSlide {
                titleSlidableController.shift(delta: offset, startIndex: startIndex, destinationIndex: destinationIndex)
            }
            lastContentOffset = actualContentOffset
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        content[currentIndex].object.didStartDragging()
//        if scrollDirection == ScrollDirection.Horizontal {
//            startDraggingContentOffset = scrollView.contentOffset.x
//        } else {
//            startDraggingContentOffset = scrollView.contentOffset.y
//        }
       // titleScrollableController.jump(currentIndex, animated: false)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollDirection == ScrollDirection.Horizontal {
//            if startDraggingContentOffset == scrollView.contentOffset.x {
//                content[currentIndex].object.didCancelDragging()
//            }
//        } else {
//            if startDraggingContentOffset == scrollView.contentOffset.y {
//                content[currentIndex].object.didCancelDragging()
//            }
//        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        removeContentIfNeeded()
        didFinishForceSlide?()

        isForcedToSlide = false
    }
    
    // MARK: - ViewableImplementation
    public var view: UIView {
        return containerView
    }
}

// MARK: - PrivateScrollController
private extension SlideController {
    func calculateContentPageSize(direction: SlideDirection, titleViewAlignment: TitleViewAlignment, titleViewPosition: TitleViewPosition, titleSize: CGFloat) -> CGFloat {
        var contentPageSize: CGFloat!
        if direction == SlideDirection.horizontal {
            if (titleViewAlignment == TitleViewAlignment.left || titleViewAlignment == TitleViewAlignment.right) && titleViewPosition == TitleViewPosition.beside {
                contentPageSize = containerView.frame.width - titleSlidableController.titleView.titleSize
            } else {
                contentPageSize = containerView.frame.width
            }
        } else {
            if titleViewPosition == TitleViewPosition.beside &&  titleViewAlignment == TitleViewAlignment.top {
                contentPageSize = containerView.frame.height - titleSlidableController.titleView.titleSize
            } else {
                contentPageSize = containerView.frame.height
            }
        }
        return contentPageSize
    }
    
    func isIndexValid(index: Int) -> Bool {
        if index >= content.count || index < 0 {
            return false
        }
        return true
    }
    
    func loadView(pageIndex: Int) {
        loadViewIfNeeded(pageIndex: pageIndex - 1)
        loadViewIfNeeded(pageIndex: pageIndex, truePage: true)
        loadViewIfNeeded(pageIndex: pageIndex + 1)
    }
    
    func loadViewIfNeeded(pageIndex: Int, truePage: Bool = false) {
        if isIndexValid(index: pageIndex) {
            if !contentSlidableController.containers[pageIndex].hasContent {
                contentSlidableController.containers[pageIndex].load(view: content[pageIndex].lifeCycleObject.view)
                content[pageIndex].lifeCycleObject.viewDidLoad()

            }
            if truePage {
                if isOnScreen {
                    if currentIndex != pageIndex {
                        if content.indices.contains(currentIndex) {
                            content[currentIndex].lifeCycleObject.didDissapear()
                        }
                        currentIndex = pageIndex
                    }
                    content[pageIndex].lifeCycleObject.didAppear()
                } else {
                    currentIndex = pageIndex
                }
            }
        }
    }
    
    func shiftKeyboardIfNeeded(offset: CGFloat) {
        guard content.indices.contains(currentIndex) else {
            return
        }
        if content[currentIndex].lifeCycleObject.isKeyboardResponsive && slideDirection == SlideDirection.horizontal {
            if let keyBoardView = findKeyboardWindow() {
                var frame = keyBoardView.frame
                frame.origin.x = frame.origin.x + offset
                keyBoardView.frame = frame
            }
        }
    }
    
    func findKeyboardWindow () -> UIWindow? {
        for window in UIApplication.shared.windows {
            if window.isKind(of: NSClassFromString("UIRemoteKeyboardWindow")!) {
                return window
            }
        }
        return nil
    }

    func removeContentIfNeeded() {
        guard let index = indexToRemove, shouldRemoveContentAfterAnimation else {
            return
        }
        shouldRemoveContentAfterAnimation = false
        indexToRemove = nil
        content.remove(at: index)
        contentSlidableController.removeAtIndex(index: index)
        titleSlidableController.removeAtIndex(index: index)
    }
}
