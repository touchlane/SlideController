//
//  TitleItem.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class HorizontalTitleItem: UIView, Initializable, ItemViewable, Selectable {
    let titleLabel = UILabel()
    
    private var titleLabelOffsetX: CGFloat = 21
    private var internalIsSelected: Bool = false
    private var internalIndex: Int = 0
    private var internalDidSelectAction: ((Int) -> Void)?
    
    private let titleLabelFont = UIFont.systemFont(ofSize: 16.5)
    private let internalBackgroundColor = UIColor.clear
    private let titleFontDefaultColor = UIColor(white: 1, alpha: 0.7)
    private let titleFontSelectedColor = UIColor(white: 1, alpha: 1)
    
    required init() {
        super.init(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabelFont
        addSubview(titleLabel)
        activateTitleLabelConstraints(view: titleLabel)
        isSelected = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ItemViewableImplementation
    
    typealias Item = HorizontalTitleItem
    
    var view: Item {
        return self
    }
    
    // MARK: - SelectableImplementation
    
    var didSelectAction: ((Int) -> Void)? {
        get {
            return internalDidSelectAction
        }
        set {
            internalDidSelectAction = newValue
        }
    }
    
    var isSelected: Bool {
        get {
            return internalIsSelected
        }
        set {
            if newValue {
                titleLabel.textColor = titleFontSelectedColor
            } else {
                titleLabel.textColor = titleFontDefaultColor
            }
            internalIsSelected = newValue
        }
    }
    
    var index: Int {
        get {
            return internalIndex
        }
        set {
            internalIndex = newValue
        }
    }
}

private typealias PrivateHorizontalTitleItem = HorizontalTitleItem
private extension PrivateHorizontalTitleItem {
    func activateTitleLabelConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -titleLabelOffsetX))
        constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: titleLabelOffsetX))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tapDetected(_ recognizer: UIGestureRecognizer) {
        if !internalIsSelected {
            internalDidSelectAction?(internalIndex)
        }
    }
}
