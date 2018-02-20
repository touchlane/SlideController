//
//  HorizontalView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class HorizontalView : UIView {
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateContentViewConstraints(view: view)
            }
        }
    }
   
    var optionsView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = optionsView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateOptionsViewConstraints(view: view)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias PrivateHorizontalView = HorizontalView
private extension PrivateHorizontalView {
    func activateContentViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateOptionsViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor, constant: 44))
        NSLayoutConstraint.activate(constraints)
    }
}

