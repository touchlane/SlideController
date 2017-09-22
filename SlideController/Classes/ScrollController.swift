//
//  ScrollController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

public protocol PageScrollViewLifeCycle: class {
    func didAppear()
    func didDissapear()
    func viewDidLoad()
    func didStartScrolling()
    func didCancelScrolling()
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

public protocol TitleScrollable: class {
    var didSelectItemAction: ((Int, (() -> ())?) -> ())? { get set }
    func jump(index: Int, animated: Bool)
    func shift(delta: CGFloat, startIndex: Int, destinationIndex: Int)
    init(pagesCount: Int, scrollDirection: ScrollDirection)
}

public protocol ViewScrollable: class {
    associatedtype View: UIView
    func appendViews(views: [View])
    func insertView(view: View, index: Int)
    func removeViewAtIndex(index: Int)
    var firstLayoutAction: (() -> ())? { get set }
    var isLayouted: Bool { get }
}

public protocol ControllerScrollable: class {
    func shift(pageIndex: Int, animated: Bool)
    func showNext(animated: Bool)
    func viewDidAppear()
    func viewDidDisappear()
    func insert(object : ScrollLifeCycleObjectProvidable, index : Int)
    func append(object : [ScrollLifeCycleObjectProvidable])
    func removeAtIndex(index : Int)
}

public protocol TextSettable {
    var text: String? { get set }
}

public protocol Selectable: class {
    var isSelected: Bool { get set }
    var didSelectAction: ((Int) -> ())? { get set }
    var index: Int { get set }
}

public enum ScrollDirection {
    case Vertical
    case Horizontal
}

public enum TitleViewAlignment {
    case Top
    case Left
    case Right
}

public enum TitleViewPosition {
    case Beside
    case Above
}

public typealias TitleItemObject = Selectable & ItemViewable
public typealias TitleItemControllableObject = ItemViewable & Initializable & Selectable
public typealias ScrollLifeCycleObject = PageScrollViewLifeCycle & Viewable & Initializable

public class ScrollController<T, N>: NSObject, UIScrollViewDelegate, ControllerScrollable, Viewable where T: ViewScrollable, T: UIScrollView, T: TitleConfigurable, N: TitleItemControllableObject, N: UIView, N.Item == T.View {
    
    public var titleView: T {
        return titleScrollableController.titleView
    }
    
    internal var currentModel: ScrollLifeCycleObjectProvidable? {
        if isIndexValid(index: currentIndex) {
            return content[currentIndex]
        }
        return nil
    }
    
    public fileprivate(set) var content = [ScrollLifeCycleObjectProvidable]()
    
    fileprivate let containerView = ScrollContainerView<T>()
    fileprivate var titleScrollableController: TitleScrollableController<T, N>!
    fileprivate var scrollDirection: ScrollDirection!
    fileprivate var contentScrollableController: ContentScrollableController!
    fileprivate var currentIndex = 0
    fileprivate var lastContentOffset: CGFloat = 0
    fileprivate var didFinishForceScroll: (() -> ())?
    fileprivate var isForcedToScroll: Bool = false
    fileprivate var isOnScreen = false
    fileprivate var scrollInProgress: Bool = false

    //TODO: Refactoring. we had to add the flag to prevent crash when the current page is being removed
    fileprivate var shouldRemoveContentAfterAnimation: Bool = false
    fileprivate var indexToRemove: Int?

    private lazy var firstLayoutTitleAction: () -> () = { [weak self] in
        guard let `self` = self else { return }
        self.titleScrollableController.jump(index: self.currentIndex, animated: false)
    }
    
    private lazy var firstLayoutContentAction: () -> () = { [weak self] in
        guard let `self` = self else { return }
        self.contentScrollableController.pageSize = self.calculateContentPageSize(direction: self.scrollDirection, titleViewAlignment: self.titleScrollableController.titleView.alignment, titleViewPosition: self.titleScrollableController.titleView.position, titleSize: self.titleScrollableController.titleView.titleSize)
        self.contentScrollableController.scrollView.delegate = self
        self.shift(pageIndex: self.currentIndex, animated: false)
    }
    
    func didSelectTitleItem(index: Int, completion: @escaping () -> ()) {
        loadViewIfNeeded(pageIndex: index)
        isForcedToScroll = true
        shift(pageIndex: index)
        didFinishForceScroll = completion
    }
    
    private lazy var didSelectItemAction: (Int, (() -> ())?) -> () = { [weak self] (index, completion) in
        guard let `self` = self else { return }
        self.loadViewIfNeeded(pageIndex: index)
        self.isForcedToScroll = true
        self.shift(pageIndex: index)
        self.didFinishForceScroll = completion
    }

    public init(pagesContent : [ScrollLifeCycleObjectProvidable], startPageIndex: Int = 0, scrollDirection : ScrollDirection) {
        super.init()
        content = pagesContent
        self.scrollDirection = scrollDirection
        titleScrollableController = TitleScrollableController(pagesCount: content.count, scrollDirection: scrollDirection)
        currentIndex = startPageIndex
        contentScrollableController = ContentScrollableController(pagesCount: content.count, scrollDirection: scrollDirection)
        titleScrollableController.didSelectItemAction = didSelectItemAction
        loadView(pageIndex: currentIndex)
        containerView.contentView = contentScrollableController.scrollView
        containerView.titleView = titleScrollableController.titleView
        titleScrollableController.titleView.firstLayoutAction = firstLayoutTitleAction
        contentScrollableController.scrollView.firstLayoutAction = firstLayoutContentAction
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            contentScrollableController.scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    //MARK: - ControllerScrollable_Implementation
    
    public func append(object objects : [ScrollLifeCycleObjectProvidable]) {

        if objects.count > 0 {
            content.append(contentsOf: objects)
            contentScrollableController.append(pagesCount: objects.count)
            titleScrollableController.append(pagesCount: objects.count)
            if contentScrollableController.scrollView.isLayouted {
                contentScrollableController.scrollView.layoutIfNeeded()
            }
            if titleScrollableController.titleView.isLayouted {
                titleScrollableController.titleView.layoutIfNeeded()
            }
            loadView(pageIndex: currentIndex)
        }
    }

    public func insert(object : ScrollLifeCycleObjectProvidable, index : Int) {
        guard index < content.count else { return }
        content.insert(object, at: index)
        contentScrollableController.insert(index: index)
        titleScrollableController.insert(index: index)
        if contentScrollableController.scrollView.isLayouted {
           contentScrollableController.scrollView.layoutIfNeeded()
        }
        if titleScrollableController.titleView.isLayouted {
            titleScrollableController.titleView.layoutIfNeeded()
        }
        if index <= currentIndex {
            // FIXME: workaround to fix life cycle calls  
            contentScrollableController.scrollView.delegate = nil
            shift(pageIndex: currentIndex + 1, animated: false)
            currentIndex = currentIndex + 1
            titleScrollableController.jump(index: currentIndex, animated: false)
            contentScrollableController.scrollView.delegate = self
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
            contentScrollableController.removeAtIndex(index: index)
            titleScrollableController.removeAtIndex(index: index)
        } else {
            indexToRemove = index
        }

        if contentScrollableController.scrollView.isLayouted {
            contentScrollableController.scrollView.layoutIfNeeded()
        }
        if titleScrollableController.titleView.isLayouted {
            titleScrollableController.titleView.layoutIfNeeded()
        }
        if index < currentIndex {
            shift(pageIndex: currentIndex - 1, animated: false)
        } else if index == currentIndex {
            if currentIndex < content.count - (shouldRemoveContentAfterAnimation ? 1: 0) {
                titleScrollableController.jump(index: currentIndex, animated: false)

                removeContentIfNeeded()
            } else {
                shift(pageIndex: currentIndex - 1, animated: true)
            }
        }
        loadView(pageIndex: currentIndex)
    }
    
    public func shift(pageIndex: Int, animated: Bool = true) {
        if !self.contentScrollableController.scrollView.isLayouted {
            currentIndex = pageIndex
            loadView(pageIndex: currentIndex)
        } else {
            contentScrollableController.scrollToPage(pageIndex, animated: animated)
            if scrollDirection == ScrollDirection.Horizontal {
                lastContentOffset = contentScrollableController.scrollView.contentOffset.x
            } else {
                lastContentOffset = contentScrollableController.scrollView.contentOffset.y
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
            content[currentIndex].lifeCycleObject.didStartScrolling()
            scrollInProgress = true
        }
        let pageSize = contentScrollableController.pageSize
        var actualContentOffset: CGFloat = 0
        if scrollDirection == ScrollDirection.Horizontal {
            actualContentOffset = scrollView.contentOffset.x
        } else {
            actualContentOffset = scrollView.contentOffset.y
        }
        let actualIndex = Int(actualContentOffset / pageSize)
        if actualContentOffset.truncatingRemainder(dividingBy: pageSize) == 0.0 {
            let nextIndex = actualIndex
            if nextIndex != currentIndex {
                loadView(pageIndex: nextIndex)
                titleScrollableController.jump(index: nextIndex, animated: false)
            } else {
                content[currentIndex].lifeCycleObject.didCancelScrolling()
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
            if !isForcedToScroll {
                titleScrollableController.shift(delta: offset, startIndex: startIndex, destinationIndex: destinationIndex)
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
        didFinishForceScroll?()

        isForcedToScroll = false
    }
    
    // MARK: - ViewableImplementation
    public var view: UIView {
        return containerView
    }
}

// MARK: - PrivateScrollController
private extension ScrollController {
    func calculateContentPageSize(direction: ScrollDirection, titleViewAlignment: TitleViewAlignment, titleViewPosition: TitleViewPosition, titleSize: CGFloat) -> CGFloat {
        var contentPageSize: CGFloat!
        if direction == ScrollDirection.Horizontal {
            if (titleViewAlignment == TitleViewAlignment.Left || titleViewAlignment == TitleViewAlignment.Right) && titleViewPosition == TitleViewPosition.Beside {
                contentPageSize = containerView.frame.width - titleScrollableController.titleView.titleSize
            } else {
                contentPageSize = containerView.frame.width
            }
        } else {
            if titleViewPosition == TitleViewPosition.Beside &&  titleViewAlignment == TitleViewAlignment.Top {
                contentPageSize = containerView.frame.height - titleScrollableController.titleView.titleSize
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
            if !contentScrollableController.controllers[pageIndex].isContentLoaded() {
                contentScrollableController.controllers[pageIndex].load(childView: content[pageIndex].lifeCycleObject.view)
                content[pageIndex].lifeCycleObject.viewDidLoad()
                
            }
            if truePage {
                if isOnScreen {
                    if currentIndex != pageIndex {
                        content[currentIndex].lifeCycleObject.didDissapear()
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
        if content[currentIndex].lifeCycleObject.isKeyboardResponsive && scrollDirection == ScrollDirection.Horizontal {
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
        contentScrollableController.removeAtIndex(index: index)
        titleScrollableController.removeAtIndex(index: index)
    }
}
