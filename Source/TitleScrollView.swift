//
//  TitleScrollView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

public protocol TitleConfigurable: class {
    associatedtype TitleItem: UIView
    var items: [TitleItem] { get }
    var alignment: TitleViewAlignment { get set }
    var position: TitleViewPosition { get set }
    var titleSize: CGFloat { get set }
    
    /// Called when user slides or shifts content,
    /// Use this method to implement sliding indicator
    /// - Parameters:
    ///   - position: updated position for sliding indicator (x or y depends for horizontal and vertical respectively)
    ///   - size: updated size for indicator (width or height for horizontal and vertical respectively)
    ///   - animated: should update position and size animated
    func indicator(position: CGFloat, size: CGFloat, animated: Bool)
    
    weak var titleViewConfigurationDelegate: TitleViewConfigurationDelegate? { get set }
}

public protocol TitleViewConfigurationDelegate: class {
    func didChangeAlignment(alignment: TitleViewAlignment)
    func didChangeTitleSize(size: CGFloat)
    func didChangePosition(position: TitleViewPosition)
}

open class TitleScrollView<T>: UIScrollView, ViewSlidable, TitleConfigurable where T: UIView, T: TitleItemObject {
    public typealias View = T
    public typealias TitleItem = View
    public private(set) var isLayouted = false
    private var previousSize = CGSize.zero
    private var previousContentSize = CGSize.zero
    
    public init() {
        super.init(frame: CGRect.zero)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !isLayouted {
            isLayouted = true
            firstLayoutAction?()
        }
        if bounds.size != previousSize || contentSize != previousContentSize {
            previousSize = bounds.size
            previousContentSize = contentSize
            changeLayoutAction?()
        }
    }
    
    // MARK: - ViewSlidableImplementation
    open func appendViews(views: [View]) { }
    
    open func insertView(view: View, index: Int) { }
    
    open func removeViewAtIndex(index: Int) { }
    
    ///Simple hack to be notified when layout completed
    open var firstLayoutAction: (() -> Void)?
    
    ///Notifies on each size or content size update
    open var changeLayoutAction: (() -> Void)?
    
    // MARK: - TitleConfigurableImplementation
    
    
    /// Alignment of title view. Supports `.top`, `.bottom`, `.left`, `.right`. The default value of `alignment` is `.top`.
    public var alignment = TitleViewAlignment.top {
        didSet {
            if alignment != oldValue {
               titleViewConfigurationDelegate?.didChangeAlignment(alignment: alignment)
            }
        }
    }
    
    /// The size of `TitleScrollView`. For `.horizontal` slide direction of `SlideController` the `titleSize` corresponds to `height`. For `.vertical` slide direction of `SlideController` the `titleSize` corresponds to `width`.  The default value of `titleSize` is `84`.
    open var titleSize: CGFloat = 84 {
        didSet {
            if titleSize != oldValue {
                titleViewConfigurationDelegate?.didChangeTitleSize(size: titleSize)
            }
        }
    }
    
    open var position = TitleViewPosition.beside {
        didSet {
            if position != oldValue {
                titleViewConfigurationDelegate?.didChangePosition(position: position)
            }
        }
    }
    
    open func indicator(position: CGFloat, size: CGFloat, animated: Bool) { }
    
    weak public var titleViewConfigurationDelegate: TitleViewConfigurationDelegate?
    
    /// Array of title items that displayed in `TitleScrollView`.
    open var items: [TitleItem] {
        return [TitleItem]()
    }
}
