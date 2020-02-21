//
//  CarouselView.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class CarouselView: UIView {
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

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias PrivateCarouselView = CarouselView
private extension PrivateCarouselView {
    func activateContentViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: topAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func activateOptionsViewConstraints(view: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: topAnchor, constant: 84))
        NSLayoutConstraint.activate(constraints)
    }
}
