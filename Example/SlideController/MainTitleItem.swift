//
//  TitleItem.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class MainTitleItem : UIView, Initializable, ItemViewable, Selectable {
    let titleLabel = UILabel()
    
    fileprivate var _titleLabelOffsetX : CGFloat = 21
    fileprivate var _newIndicatorRadius : CGFloat = 9
    fileprivate var _isSelected : Bool = false
    fileprivate var _index : Int = 0
    fileprivate var _didSelectAction : ((Int) -> ())?
    fileprivate let _backgroundView = UIView()
    fileprivate let _backgroundSelectedColor = UIColor.white
    fileprivate let _titleLabelFont = UIFont.systemFont(ofSize: 16.5)
    fileprivate let _backgroundColor = UIColor(red: 58.0/255.0, green: 28.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    fileprivate let _titleFontDefaultColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)
    fileprivate let _titleFontSelectedColor = UIColor(red: 30.0/255.0, green: 186.0/255.0, blue: 198.0/255.0, alpha: 1.0)
    
    required init() {
        super.init(frame: CGRect.zero)
        _backgroundView.translatesAutoresizingMaskIntoConstraints = false
        _backgroundView.layer.masksToBounds = true
        self.addSubview(_backgroundView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = _titleLabelFont
        self.addSubview(titleLabel)
        activateBackgroundViewConstraints(view : _backgroundView)
        activateTitleLabelConstraints(view : titleLabel)
        isSelected = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cornerRadius : CGFloat {
        get {
            return _backgroundView.layer.cornerRadius
        }
        set {
            _backgroundView.layer.cornerRadius = newValue
        }
    }
    
    //MARK: - ItemViewable_Implementation
    
    typealias Item = MainTitleItem
    
    var view : Item {
        return self
    }
    
    //MARK: - Selectable_Implementation
    
    var didSelectAction : ((Int) -> ())? {
        get {
            return _didSelectAction
        }
        set {
            _didSelectAction = newValue
        }
    }
    
    var isSelected : Bool {
        get {
            return _isSelected
        }
        set {
            if newValue {
                _backgroundView.backgroundColor = _backgroundSelectedColor
                titleLabel.textColor = _titleFontSelectedColor
            } else {
                _backgroundView.backgroundColor = _backgroundColor
                titleLabel.textColor = _titleFontDefaultColor
            }
            _isSelected = newValue
        }
    }
    
    var index : Int {
        get {
            return _index
        }
        set {
            _index = newValue
        }
    }
}

private typealias Private_MainTitleItem = MainTitleItem
private extension Private_MainTitleItem {
    func activateBackgroundViewConstraints(view : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateTitleLabelConstraints(view : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -_titleLabelOffsetX))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: _titleLabelOffsetX))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tapDetected(_ recognizer: UIGestureRecognizer) {
        if !_isSelected {
            _didSelectAction?(_index)
        }
    }
}
