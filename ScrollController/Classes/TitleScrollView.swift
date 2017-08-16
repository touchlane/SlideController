//
//  TitleView.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

protocol TitleConfigurable : class {
    associatedtype TitleItem : UIView
    var items : [TitleItem] { get }
    var alignment : TitleViewAlignment { get set }
    var position : TitleViewPosition { get set }
    var titleSize : CGFloat { get set }
    weak var titleViewConfigurationDelegate : TitleViewConfigurationDelegate? { get set }
}

protocol TitleViewConfigurationDelegate : class {
    func didChangeAlignment(alignment : TitleViewAlignment)
    func didChangeTitleSize(size : CGFloat)
    func didChangePosition(position : TitleViewPosition)
}

class TitleScrollView<T> : UIScrollView, ViewScrollable, TitleConfigurable where T: UIView, T : TitleItemObject {
    
    typealias View = T
    typealias TitleItem = View
    
    internal private(set) var isLayouted = false
    
    init() {
        super.init(frame: CGRect.zero)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayouted {
            isLayouted = true
            firstLayoutAction?()
        }
    }
    
    //MARK: - ViewScrollable_Implementation
    
    func appendViews(views: [View]) {
        
    }
    
    func insertView(view : View, index : Int) {
        
    }
    
    func removeViewAtIndex(index : Int) {
        
    }
    
    var firstLayoutAction : (() -> ())?
    
    //MARK: - TitleConfigurable_Implementation
    
    var alignment = TitleViewAlignment.Top {
        didSet {
            if alignment != oldValue {
               titleViewConfigurationDelegate?.didChangeAlignment(alignment: alignment)
            }
        }
    }
    
    var titleSize : CGFloat = 84 {
        didSet {
            if titleSize != oldValue {
                titleViewConfigurationDelegate?.didChangeTitleSize(size: titleSize)
            }
        }
    }
    
    var position = TitleViewPosition.Beside {
        didSet {
            if position != oldValue {
                titleViewConfigurationDelegate?.didChangePosition(position: position)
            }
        }
    }
    
    weak var titleViewConfigurationDelegate : TitleViewConfigurationDelegate?
    
    var items : [TitleItem] {
        return [TitleItem]()
    }
}
