//
//  VerticalTitleItem.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class VerticalTitleItem: UIView, Initializable, Selectable, ItemViewable {
    private let backgroundSelectedColor = UIColor.white
    private let backgroundViewColor = UIColor.white.withAlphaComponent(0.3)
    private let backgoundViewHeightMultiplier : CGFloat = 0.67
    private let backgroundView = UIView()
    
    required init() {
        isSelected = false
        super.init(frame: CGRect.zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = backgroundViewColor
        addSubview(backgroundView)
        activateBackgroundViewConstraints(view: backgroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var index: Int = 0
    
    // MARK: - SelectableImplementation
    
    var didSelectAction: ((Int) -> Void)?
    
    var isSelected: Bool {
        didSet {
            backgroundView.backgroundColor = isSelected ? backgroundSelectedColor : backgroundViewColor
        }
    }
    
    // MARK: - ItemViewableImplementation
    
    typealias Item = VerticalTitleItem
    
    var view: Item {
        return self
    }
}

private typealias PrivateVerticalTitleItem = VerticalTitleItem
private extension PrivateVerticalTitleItem {
    func activateBackgroundViewConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: backgoundViewHeightMultiplier)
            ])
    }
}
