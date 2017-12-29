//
//  CircularView.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class CircularView: UIView {
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

private typealias PrivateCircularView = CircularView
private extension PrivateCircularView {
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
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor, constant: 84))
        NSLayoutConstraint.activate(constraints)
    }
}
