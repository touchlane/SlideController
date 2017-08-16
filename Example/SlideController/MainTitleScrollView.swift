//
//  MainTitleScrollView.swift
//  youlive
//
//  Created by Vadim Morozov on 4/20/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class MainTitleScrollView : TitleScrollView<MainTitleItem> {
    
    fileprivate var _items = [View]()
    fileprivate let _itemOffsetX : CGFloat = 15
    fileprivate let _itemOffsetTop : CGFloat = 36
    fileprivate let _itemHeight : CGFloat = 36
    fileprivate let _shadowOpacity : Float = 0.16
    fileprivate let _viewBackgroundColor = UIColor(colorLiteralRed: 80.0/255.0, green: 44.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    
    override required init() {
        super.init()
        self.isScrollEnabled = false
        self.clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = _shadowOpacity
        backgroundColor = _viewBackgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var items : [TitleItem] {
        return _items
    }
    
    override func appendViews(views: [View]) {
        var prevView : View? = _items.last
        let prevPrevView: UIView? = _items.count > 1 ? _items[items.count - 2] : nil
        
        if let prevItem = prevView {
            updateConstraints(prevItem, prevView : prevPrevView, isLast : false)
        }
        
        for i in 0...views.count - 1 {
            let view = views[i]
            view.cornerRadius = _itemHeight / 2
            view.translatesAutoresizingMaskIntoConstraints = false
            _items.append(view)
            addSubview(view)
            activateConstraints(view, prevView: prevView, isLast: i == views.count - 1)
            prevView = view
        }
    }
    
    override func insertView(view : View, index : Int) {
        guard index < _items.count else { return }
        view.cornerRadius = _itemHeight / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        _items.insert(view, at: index)
        addSubview(view)
        let prevView : View? = index > 0 ? _items[index - 1] :  nil
        let nextView : View = _items[index + 1]
        activateConstraints(view, prevView: prevView, isLast: false)
        updateConstraints(nextView, prevView : view, isLast : index == _items.count - 2)
    }
    
    override func removeViewAtIndex(index : Int) {
        guard index < _items.count else { return }
        let view : View = _items[index]
        let prevView : View? = index > 0 ? _items[index - 1] : nil
        let nextView : View? = index < _items.count - 1 ? _items[index + 1] : nil
        
        _items.remove(at: index)
        view.removeFromSuperview()
        if let nextView = nextView {
            updateConstraints(nextView, prevView: prevView, isLast: index == _items.count - 1)
        } else if let prevView = prevView {
            let prevPrevView : View? = _items.count > 1 ? _items[_items.count - 2] : nil
            updateConstraints(prevView, prevView: prevPrevView, isLast: true)
        }
    }
}

private typealias Private_MainTitleScrollView = MainTitleScrollView
private extension Private_MainTitleScrollView {
    func activateConstraints(_ view : UIView, prevView : UIView?, isLast : Bool) {
        view.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(_itemOffsetTop)
            make.height.equalTo(_itemHeight)
        })
        if let prevView = prevView {
            view.snp.makeConstraints({ (make) in
                make.leading.equalTo(prevView.snp.trailing).offset(2 * itemOffsetX())
            })
        } else {
            view.snp.makeConstraints({ (make) in
                make.leading.equalTo(self.snp.leading).offset(itemOffsetX())
            })
        }
        if isLast {
            view.snp.makeConstraints({ (make) in
                make.trailing.equalTo(self.snp.trailing).offset(-itemOffsetX())
            })
        }
    }
    
    func updateConstraints(_ view : UIView, prevView : UIView?, isLast : Bool) {
        view.snp.removeConstraints()
        activateConstraints(view, prevView : prevView, isLast : isLast)
    }
    
    func itemOffsetX() -> CGFloat {
        return _itemOffsetX
    }
}
