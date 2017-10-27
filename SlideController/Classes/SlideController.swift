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
    func viewDidUnload()
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
    var firstLayoutAction: (() -> Void)? { get set }
    var changeLayoutAction: (() -> Void)? { get set }
    var isLayouted: Bool { get }
}

public protocol ControllerSlidable: class {
    func shift(pageIndex: Int, animated: Bool)
    func showNext(animated: Bool)
    func viewDidAppear()
    func viewDidDisappear()
    func insert(object: SlideLifeCycleObjectProvidable, index: Int)
    func append(object: [SlideLifeCycleObjectProvidable])
    func removeAtIndex(index : Int)
}

public protocol Selectable: class {
    var isSelected: Bool { get set }
    var didSelectAction: ((Int) -> Void)? { get set }
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
    private var didFinishSlideAction: (() -> Void)?
    private var isForcedToSlide = false
    private var isOnScreen = false
    private var scrollInProgress = false
    
    ///Returns title view instanse of specified type
    public var titleView: T {
        return titleSlidableController.titleView
    }
    
    ///Returns model for access to current LifeCycle object
    public var currentModel: SlideLifeCycleObjectProvidable? {
        if content.indices.contains(currentIndex) {
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
        guard let strongSelf = self else { return }
        strongSelf.changeContentLayoutAction()
    }
    
    private lazy var firstLayoutContentAction: () -> () = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.contentSlidableController.slideContentView.delegate = self
    }
    
    private lazy var changeTitleLayoutAction: () -> () = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.titleSlidableController.jump(index: strongSelf.currentIndex, animated: false)
    }
    
    private lazy var changeContentLayoutAction: () -> () = { [weak self] in
        guard let strongSelf = self else { return }
        guard !strongSelf.isForcedToSlide else { return }
        strongSelf.contentSlidableController.contentSize = strongSelf.calculateContentPageSize(
            direction: strongSelf.slideDirection,
            titleViewAlignment: strongSelf.titleSlidableController.titleView.alignment,
            titleViewPosition: strongSelf.titleSlidableController.titleView.position,
            titleSize: strongSelf.titleSlidableController.titleView.titleSize)
        strongSelf.shift(pageIndex: strongSelf.currentIndex, animated: false)
    }
    
    private lazy var didSelectItemAction: (Int, (() -> ())?) -> () = { [weak self] (index, completion) in
        guard let strongSelf = self else { return }
        strongSelf.loadViewIfNeeded(pageIndex: index)
        strongSelf.isForcedToSlide = true
        strongSelf.shift(pageIndex: index)
        strongSelf.didFinishForceSlide = completion
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
        titleSlidableController.titleView.changeLayoutAction = changeTitleLayoutAction
        contentSlidableController.slideContentView.changeLayoutAction = changeContentLayoutAction
    }
    
    var isScrollEnabled: Bool = true {
        didSet {
            contentSlidableController.slideContentView.isScrollEnabled = isScrollEnabled
        }
    }

    // MARK: - ControllerSlidableImplementation
    
    public func append(object objects: [SlideLifeCycleObjectProvidable]) {
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
            titleSlidableController.jump(index: currentIndex, animated: false)
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
            if self.contentSlidableController.slideContentView.isLayouted {
                currentIndex = currentIndex + 1
            }
            titleSlidableController.jump(index: currentIndex, animated: false)
            contentSlidableController.slideContentView.delegate = self
            if FeatureManager().viewUnloading.isEnabled {
                unloadView(at: index - 1)
            }
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
            if currentIndex < content.count - (shouldRemoveContentAfterAnimation ? 1: 0) || content.count == 1 {
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
            loadView(pageIndex: pageIndex)
        } else {
            didFinishSlideAction = contentSlidableController.scrollToPage(index: pageIndex, animated: animated)
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
        if content.indices.contains(currentIndex) {
            content[currentIndex].lifeCycleObject.didAppear()
        }
    }
    
    public func viewDidDisappear() {
        isOnScreen = false
        if content.indices.contains(currentIndex) {
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
        let actualContentOffset = slideDirection == .horizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let didReachContentEdge = actualContentOffset.truncatingRemainder(dividingBy: pageSize) == 0.0
        if didReachContentEdge {
            let nextIndex = Int(actualContentOffset / pageSize)
            if nextIndex != currentIndex {
                loadView(pageIndex: nextIndex)
                if !isForcedToSlide {
                    titleSlidableController.jump(index: nextIndex, animated: false)
                }
            } else {
                content[currentIndex].lifeCycleObject.didCancelSliding()
            }

            removeContentIfNeeded()
            scrollInProgress = false
        } else {
            if !isForcedToSlide {
                updateTitleScrollOffset(contentOffset: actualContentOffset, pageSize: pageSize)
            }
            shiftKeyboardIfNeeded(offset: -(actualContentOffset - lastContentOffset))
            lastContentOffset = actualContentOffset
        }
    }
    
    private func updateTitleScrollOffset(contentOffset: CGFloat, pageSize: CGFloat) {
        let actualIndex = Int(contentOffset / pageSize)
        let offset = contentOffset - lastContentOffset
        var startIndex: Int
        var destinationIndex: Int
        if  offset < 0 {
            startIndex = actualIndex + 1
            destinationIndex = startIndex - 1
        } else {
            startIndex = actualIndex
            destinationIndex = startIndex + 1
        }
        titleSlidableController.shift(delta: offset, startIndex: startIndex, destinationIndex: destinationIndex)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        removeContentIfNeeded()
        didFinishForceSlide?()
        didFinishSlideAction?()
        didFinishSlideAction = nil
        isForcedToSlide = false
    }
    
    // MARK: - ViewableImplementation
    public var view: UIView {
        return containerView
    }
}

private typealias PrivateSlideController = SlideController
private extension PrivateSlideController {
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
    
    func loadView(pageIndex: Int) {
        loadViewIfNeeded(pageIndex: pageIndex - 1)
        loadViewIfNeeded(pageIndex: pageIndex, truePage: true)
        loadViewIfNeeded(pageIndex: pageIndex + 1)
    }
    
    func loadViewIfNeeded(pageIndex: Int, truePage: Bool = false) {
        if content.indices.contains(pageIndex) {
            if !contentSlidableController.containers[pageIndex].hasContent {
                contentSlidableController.containers[pageIndex].load(view: content[pageIndex].lifeCycleObject.view)
                print("Load view at index \(pageIndex)")
                content[pageIndex].lifeCycleObject.viewDidLoad()
            }
            if truePage {
                if FeatureManager().viewUnloading.isEnabled {
                    let unloadIndices = [currentIndex - 1, currentIndex, currentIndex + 1]
                    let loadIndices = [pageIndex - 1, pageIndex, pageIndex + 1]
                    for index in unloadIndices.filter({ !loadIndices.contains($0) }) {
                        unloadView(at: index)
                    }
                }
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
    
    func unloadView(at index: Int) {
        guard content.indices.contains(index) else {
            return
        }
        print("Unload view at index \(index)")
        contentSlidableController.containers[index].unloadView()
        content[index].lifeCycleObject.viewDidUnload()
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
