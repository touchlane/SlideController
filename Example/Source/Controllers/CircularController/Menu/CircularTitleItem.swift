//
//  CircularTitleItem.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class CircularTitleItem: UIView, Initializable, ItemViewable, Selectable {
    let dotView = UIView()
    
    private let dotViewOffsetX: CGFloat = 5
    private let dotViewSizeValue: CGFloat = 10
    private let dotDefaultColor = UIColor(white: 0, alpha: 0.3)
    private let dotSelectedColor = UIColor(white: 0, alpha: 1)
    private var internalIsSelected: Bool = false
    private var internalIndex: Int = 0
    private var internalDidSelectAction: ((Int) -> Void)?
    
    required init() {
        super.init(frame: CGRect.zero)
        dotView.layer.cornerRadius = dotViewSizeValue / 2
        dotView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dotView)
        activateDotViewConstraints(view: dotView)
        isSelected = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ItemViewableImplementation
    
    typealias Item = CircularTitleItem
    
    var view: Item {
        return self
    }
    
    // MARK: - SelectableImplementation
    
    var didSelectAction: ((Int) -> ())? {
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
                dotView.backgroundColor = dotSelectedColor
            } else {
                dotView.backgroundColor = dotDefaultColor
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

private typealias PrivateCircularTitleItem = CircularTitleItem
private extension PrivateCircularTitleItem {
    func activateDotViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -dotViewOffsetX))
        constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: dotViewOffsetX))
        constraints.append(view.widthAnchor.constraint(equalToConstant: dotViewSizeValue))
        constraints.append(view.heightAnchor.constraint(equalToConstant: dotViewSizeValue))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tapDetected(_ recognizer: UIGestureRecognizer) {
        if !internalIsSelected {
            internalDidSelectAction?(internalIndex)
        }
    }
}
