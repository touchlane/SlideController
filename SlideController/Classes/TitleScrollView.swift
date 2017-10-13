//
//  TitleScrollView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

public protocol TitleConfigurable: class {
    associatedtype TitleItem: UIView
    var items: [TitleItem] { get }
    var alignment: TitleViewAlignment { get set }
    var position: TitleViewPosition { get set }
    var titleSize: CGFloat { get set }
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
    
    public init() {
        super.init(frame: CGRect.zero)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
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
    }
    
    // MARK: - ViewSlidableImplementation
    open func appendViews(views: [View]) {
        
    }
    
    open func insertView(view: View, index: Int) {
        
    }
    
    open func removeViewAtIndex(index: Int) {
        
    }
    
    open var firstLayoutAction: (() -> ())?
    
    // MARK: - TitleConfigurableImplementation
    public var alignment = TitleViewAlignment.top {
        didSet {
            if alignment != oldValue {
               titleViewConfigurationDelegate?.didChangeAlignment(alignment: alignment)
            }
        }
    }
    
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
    
    weak public var titleViewConfigurationDelegate: TitleViewConfigurationDelegate?
    
    open var items: [TitleItem] {
        return [TitleItem]()
    }
}
