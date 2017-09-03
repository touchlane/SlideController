//
//  ScrollController.swift
//  youlive
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

public protocol PageScrollViewLifeCycle : class {
    func didAppear()
    func didDissapear()
    func viewDidLoad()
    func didStartScrolling()
    func didCancelScrolling()
    var isKeyboardResponsive : Bool { get }
}

public protocol Viewable : class {
    var view : UIView { get }
}

public protocol ItemViewable : class {
    associatedtype Item : UIView
    var view : Item { get }
}

public protocol Initializable : class {
    init()
}

public protocol TitleScrollable : class {
    var didSelectItemAction : ((Int, (() -> ())?) -> ())? { get set }
    func jump(index : Int, animated : Bool)
    func shift(delta : CGFloat, startIndex : Int, destinationIndex : Int)
    init(pagesCount: Int, scrollDirection : ScrollDirection)
}

public protocol ViewScrollable : class {
    associatedtype View : UIView
    func appendViews(views : [View])
    func insertView(view : View, index : Int)
    func removeViewAtIndex(index : Int)
    var firstLayoutAction : (() -> ())? { get set }
    var isLayouted : Bool { get }
}

public protocol ControllerScrollable : class {
    func shift(pageIndex : Int, animated : Bool)
    func showNext(animated : Bool)
    func viewDidAppear()
    func viewDidDisappear()
    func insert(object : PageScrollViewModel, index : Int)
    func append(object : [PageScrollViewModel])
    func removeAtIndex(index : Int)
}

public protocol TextSettable {
    var text : String? { get set }
}

public protocol Selectable : class {
    var isSelected : Bool { get set }
    var didSelectAction : ((Int) -> ())? { get set }
    var index : Int { get set }
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

public class ScrollController<T, N> : NSObject, UIScrollViewDelegate, ControllerScrollable, Viewable where T : ViewScrollable, T : UIScrollView, T : TitleConfigurable, N : TitleItemControllableObject, N : UIView, N.Item == T.View {
    
    public var titleView : T {
        return _titleScrollableController.titleView
    }
    
    internal var _currentModel : PageScrollViewModel? {
        if isIndexValid(index: _currentIndex) {
            return content[_currentIndex]
        }
        return nil
    }
    
    fileprivate let _containerView = ScrollContainerView<T>()
    fileprivate var _titleScrollableController : TitleScrollableController<T, N>!
    internal fileprivate(set) var content = [PageScrollViewModel]()
    fileprivate var _scrollDirection : ScrollDirection!
    fileprivate var _contentScrollableController : ContentScrollableController!
    fileprivate var _currentIndex = 0
    fileprivate var _lastContentOffset : CGFloat = 0
    fileprivate var _didFinishForceScroll : (() -> ())?
    fileprivate var _isForcedToScroll : Bool = false
    fileprivate var _isOnScreen = false
    fileprivate var _scrollInProgress : Bool = false

    //TODO: Refactoring. we had to add the flag to prevent crash when the current page is being removed
    fileprivate var _shouldRemoveContentAfterAnimation: Bool = false
    fileprivate var _indexToRemove: Int?

    private lazy var _firstLayoutTitleAction : () -> () = { [weak self] in
        guard let `self` = self else { return }
        self._titleScrollableController.jump(index: self._currentIndex, animated: false)
    }
    
    private lazy var _firstLayoutContentAction : () -> () = { [weak self] in
        guard let `self` = self else { return }
        self._contentScrollableController.pageSize = self.calculateContentPageSize(direction: self._scrollDirection, titleViewAlignment: self._titleScrollableController.titleView.alignment, titleViewPosition: self._titleScrollableController.titleView.position, titleSize: self._titleScrollableController.titleView.titleSize)
        self._contentScrollableController.scrollView.delegate = self
        self.shift(pageIndex: self._currentIndex, animated: false)
    }
    
    public func didSelectTitleItem(index : Int, completion : @escaping () -> ()) {
        loadViewIfNeeded(pageIndex: index)
        _isForcedToScroll = true
        shift(pageIndex: index)
        _didFinishForceScroll = completion
    }
    
    private lazy var _didSelectItemAction : (Int, (() -> ())?) -> () = { [weak self] (index, completion) in
        guard let `self` = self else { return }
        self.loadViewIfNeeded(pageIndex: index)
        self._isForcedToScroll = true
        self.shift(pageIndex: index)
        self._didFinishForceScroll = completion
    }
    
    public init(pagesContent : [PageScrollViewModel], startPageIndex: Int = 0, scrollDirection : ScrollDirection) {
        super.init()
        content = pagesContent
        _scrollDirection = scrollDirection
        _titleScrollableController = TitleScrollableController(pagesCount: content.count, scrollDirection: scrollDirection)
        _currentIndex = startPageIndex
        _contentScrollableController = ContentScrollableController(pagesCount: content.count, scrollDirection: _scrollDirection)
        _titleScrollableController.didSelectItemAction = _didSelectItemAction
        loadView(pageIndex: _currentIndex)
        _containerView.contentView = _contentScrollableController.scrollView
        _containerView.titleView = _titleScrollableController.titleView
        _titleScrollableController.titleView.firstLayoutAction = _firstLayoutTitleAction
        _contentScrollableController.scrollView.firstLayoutAction = _firstLayoutContentAction
    }
    
    public var isScrollEnabled : Bool = true {
        didSet {
            _contentScrollableController.scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    
    private func layoutIfNeeded() {
        if _contentScrollableController.scrollView.isLayouted {
            _contentScrollableController.scrollView.layoutIfNeeded()
        }
        if _titleScrollableController.titleView.isLayouted {
            _titleScrollableController.titleView.layoutIfNeeded()
        }
    }
    
    //MARK: - ControllerScrollable_Implementation
    
    public func append(object objects : [PageScrollViewModel]) {
        if objects.count > 0 {
            content.append(contentsOf: objects)
            _contentScrollableController.append(pagesCount: objects.count)
            _titleScrollableController.append(pagesCount: objects.count)
            layoutIfNeeded()
            loadView(pageIndex: _currentIndex)
        }
    }
    
    public func insert(object : PageScrollViewModel, index : Int) {
        guard index <= content.count else { return }
        content.insert(object, at: index)
        _contentScrollableController.insert(index: index)
        _titleScrollableController.insert(index: index)
        layoutIfNeeded()
        if index <= _currentIndex {
            // FIXME: workaround to fix life cycle calls  
            _contentScrollableController.scrollView.delegate = nil
            shift(pageIndex: _currentIndex + 1, animated: false)
            _currentIndex = _currentIndex + 1
            _titleScrollableController.jump(index: _currentIndex, animated: false)
            _contentScrollableController.scrollView.delegate = self
            loadViewIfNeeded(pageIndex: index)
        } else {
            loadView(pageIndex: _currentIndex)
        }
    }
    
    public func removeAtIndex(index : Int) {
        guard index < content.count else { return }

        //TODO: Refactoring. we had to add the flag to prevent crash when the current page is being removed
        _shouldRemoveContentAfterAnimation = index == _currentIndex
        if !_shouldRemoveContentAfterAnimation {
            content.remove(at: index)
            _contentScrollableController.removeAtIndex(index: index)
            _titleScrollableController.removeAtIndex(index: index)
        } else {
            _indexToRemove = index
        }

        layoutIfNeeded()
        if index < _currentIndex {
            shift(pageIndex: _currentIndex - 1, animated: false)
        } else if index == _currentIndex {
            if _currentIndex < content.count - (_shouldRemoveContentAfterAnimation ? 1 : 0) {
                _titleScrollableController.jump(index: _currentIndex, animated : false)

                removeContentIfNeeded()
            } else {
                shift(pageIndex: _currentIndex - 1, animated: true)
            }
        }
        loadView(pageIndex: _currentIndex)
    }
    
    public func shift(pageIndex : Int, animated : Bool = true) {
        if !self._contentScrollableController.scrollView.isLayouted {
            _currentIndex = pageIndex
            loadView(pageIndex: _currentIndex)
        } else {
            _contentScrollableController.scrollToPage(pageIndex, animated: animated)
            if _scrollDirection == ScrollDirection.Horizontal {
                _lastContentOffset = _contentScrollableController.scrollView.contentOffset.x
            } else {
                _lastContentOffset = _contentScrollableController.scrollView.contentOffset.y
            }
        }
    }
    
    public func showNext(animated : Bool = true) {
        var page = _currentIndex + 1
        var animated = animated
        if page >= content.count {
            page = 0
            animated = false
        }
        shift(pageIndex: page, animated: animated)
    }
    
    public func viewDidAppear() {
        _isOnScreen = true
        if isIndexValid(index: _currentIndex) {
            content[_currentIndex].object.didAppear()
        }
    }
    
    public func viewDidDisappear() {
        _isOnScreen = false
        if isIndexValid(index: _currentIndex) {
            content[_currentIndex].object.didDissapear()
        }
    }
    
    //MARK: - UIScrollViewDelegate_Implementation
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !_scrollInProgress {
            content[_currentIndex].object.didStartScrolling()
            _scrollInProgress = true
        }
        let pageSize = _contentScrollableController.pageSize
        var actualContentOffset : CGFloat = 0
        if _scrollDirection == ScrollDirection.Horizontal {
            actualContentOffset = scrollView.contentOffset.x
        } else {
            actualContentOffset = scrollView.contentOffset.y
        }
        let actualIndex = Int(actualContentOffset / pageSize)
        if actualContentOffset.truncatingRemainder(dividingBy: pageSize) == 0.0 {
            let nextIndex = actualIndex
            if nextIndex != _currentIndex {
                loadView(pageIndex: nextIndex)
                _titleScrollableController.jump(index: nextIndex, animated : false)
            } else {
                content[_currentIndex].object.didCancelScrolling()
            }

            removeContentIfNeeded()

            _scrollInProgress = false
        } else {
            let offset = actualContentOffset - _lastContentOffset
            var startIndex : Int
            var destinationIndex : Int
            if  offset < 0 {
                startIndex = actualIndex + 1
                destinationIndex = startIndex - 1
            } else {
                startIndex = actualIndex
                destinationIndex = startIndex + 1
            }
            shiftKeyboardIfNeeded(offset: -offset)
            if !_isForcedToScroll {
                _titleScrollableController.shift(delta: offset, startIndex: startIndex, destinationIndex: destinationIndex)
            }
            _lastContentOffset = actualContentOffset
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        content[_currentIndex].object.didStartDragging()
//        if _scrollDirection == ScrollDirection.Horizontal {
//            _startDraggingContentOffset = scrollView.contentOffset.x
//        } else {
//            _startDraggingContentOffset = scrollView.contentOffset.y
//        }
       // _titleScrollableController.jump(_currentIndex, animated: false)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if _scrollDirection == ScrollDirection.Horizontal {
//            if _startDraggingContentOffset == scrollView.contentOffset.x {
//                content[_currentIndex].object.didCancelDragging()
//            }
//        } else {
//            if _startDraggingContentOffset == scrollView.contentOffset.y {
//                content[_currentIndex].object.didCancelDragging()
//            }
//        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        removeContentIfNeeded()
        _didFinishForceScroll?()

        _isForcedToScroll = false
    }
    
    //MARK: - Viewable_Implementation
    
    public var view : UIView {
        return _containerView
    }
}

//MARK: - Private_ScrollController

private extension ScrollController {
    func calculateContentPageSize(direction : ScrollDirection, titleViewAlignment : TitleViewAlignment, titleViewPosition : TitleViewPosition, titleSize : CGFloat) -> CGFloat {
        var contentPageSize : CGFloat!
        if direction == ScrollDirection.Horizontal {
            if (titleViewAlignment == TitleViewAlignment.Left || titleViewAlignment == TitleViewAlignment.Right) && titleViewPosition == TitleViewPosition.Beside {
                contentPageSize = _containerView.frame.width - _titleScrollableController.titleView.titleSize
            } else {
                contentPageSize = _containerView.frame.width
            }
        } else {
            if titleViewPosition == TitleViewPosition.Beside &&  titleViewAlignment == TitleViewAlignment.Top {
                contentPageSize = _containerView.frame.height - _titleScrollableController.titleView.titleSize
            } else {
                contentPageSize = _containerView.frame.height
            }
        }
        return contentPageSize
    }
    
    func isIndexValid(index : Int) -> Bool {
        if index >= content.count || index < 0 {
            return false
        }
        return true
    }
    
    func loadView(pageIndex : Int) {
        loadViewIfNeeded(pageIndex: pageIndex - 1)
        loadViewIfNeeded(pageIndex: pageIndex, truePage: true)
        loadViewIfNeeded(pageIndex: pageIndex + 1)
    }
    
    func loadViewIfNeeded(pageIndex : Int, truePage : Bool = false) {
        if isIndexValid(index: pageIndex) {
            if !_contentScrollableController.controllers[pageIndex].isContentLoaded(){
                _contentScrollableController.controllers[pageIndex].loadView(content[pageIndex].object.view)
                content[pageIndex].object.viewDidLoad()
                
            }
            if truePage {
                if _isOnScreen {
                    if _currentIndex != pageIndex {
                        content[_currentIndex].object.didDissapear()
                        _currentIndex = pageIndex
                    }
                    content[pageIndex].object.didAppear()


                } else {
                    _currentIndex = pageIndex
                }


            }
        }
    }
    
    func shiftKeyboardIfNeeded(offset : CGFloat) {
        if content[_currentIndex].object.isKeyboardResponsive && _scrollDirection == ScrollDirection.Horizontal {
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
        guard let index = _indexToRemove, _shouldRemoveContentAfterAnimation else {
            return
        }
        _shouldRemoveContentAfterAnimation = false
        _indexToRemove = nil
        content.remove(at: index)
        _contentScrollableController.removeAtIndex(index: index)
        _titleScrollableController.removeAtIndex(index: index)
    }
}
