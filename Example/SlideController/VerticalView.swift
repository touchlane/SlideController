//
//  VerticalView.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import Foundation
import UIKit

class VerticalView: UIView {
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)
                activateContentViewConstraints(view: view)
            }
        }
    }
    
    var optionsView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = optionsView {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)
                activateOptionsViewConstraints(view: view)
            }
        }
    }
}

private typealias PrivateVerticalView = VerticalView
private extension PrivateVerticalView {
    func activateContentViewConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor)
            ])
    }
    
    func activateOptionsViewConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor)
            ])
        
    }
}
