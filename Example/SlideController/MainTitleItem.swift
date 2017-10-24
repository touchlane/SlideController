//
//  TitleItem.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class MainTitleItem : UIView, Initializable, ItemViewable, Selectable {
    let titleLabel = UILabel()
    
    private var backgroundViewHeight: CGFloat = 2
    private var titleLabelOffsetX: CGFloat = 21
    private var newIndicatorRadius: CGFloat = 9
    private var internalIsSelected: Bool = false
    private var internalIndex: Int = 0
    private var internalDidSelectAction: ((Int) -> ())?
    private let backgroundView = UIView()
    private let backgroundSelectedColor = UIColor.white
    private let titleLabelFont = UIFont.systemFont(ofSize: 16.5)
    private let internalBackgroundColor = UIColor.clear
    private let titleFontDefaultColor = UIColor(white: 1, alpha: 0.7)
    private let titleFontSelectedColor = UIColor(white: 1, alpha: 1)
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabelFont
        self.addSubview(titleLabel)
        activateBackgroundViewConstraints(view: backgroundView)
        activateTitleLabelConstraints(view: titleLabel)
        isSelected = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ItemViewableImplementation
    
    typealias Item = MainTitleItem
    
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
                backgroundView.backgroundColor = backgroundSelectedColor
                titleLabel.textColor = titleFontSelectedColor
            } else {
                backgroundView.backgroundColor = internalBackgroundColor
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

private typealias PrivateMainTitleItem = MainTitleItem
private extension PrivateMainTitleItem {
    func activateBackgroundViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.heightAnchor.constraint(equalToConstant: backgroundViewHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateTitleLabelConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -titleLabelOffsetX))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleLabelOffsetX))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tapDetected(_ recognizer: UIGestureRecognizer) {
        if !internalIsSelected {
            internalDidSelectAction?(internalIndex)
        }
    }
}
