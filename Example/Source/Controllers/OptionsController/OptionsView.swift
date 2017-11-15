//
//  OptionsView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol OptionsViewProtocol: class {
    var horizontalDemoButton: Actionable { get }
    var verticalDemoButton: Actionable { get }
}

class OptionsView: UIView {
    private let optionButtonWidth: CGFloat = 220
    private let optionButtonHeigh: CGFloat = 32
    private let horizontalDemoButtonCenterYOffset: CGFloat = -16
    private let verticalDemoButtonCenterYOffset: CGFloat = 16
    private let internalHorizontalDemoButton = FilledButton()
    private let internalVerticalDemoButton = FilledButton()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black
        internalHorizontalDemoButton.setTitle(NSLocalizedString("HorizontalSampleButtonTitle", comment: ""),
                                              for: .normal)
        internalHorizontalDemoButton.clipsToBounds = true
        internalHorizontalDemoButton.layer.cornerRadius = optionButtonHeigh / 2
        internalHorizontalDemoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalHorizontalDemoButton)
        activateOptionBtnConstraints(view: internalHorizontalDemoButton, centerYOffset: horizontalDemoButtonCenterYOffset)
        internalVerticalDemoButton.setTitle(NSLocalizedString("VerticalSampleButtonTitle", comment: ""),
                                            for: .normal)
        internalVerticalDemoButton.clipsToBounds = true
        internalVerticalDemoButton.layer.cornerRadius = optionButtonHeigh / 2
        internalVerticalDemoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalVerticalDemoButton)
        activateOptionBtnConstraints(view: internalVerticalDemoButton, centerYOffset: verticalDemoButtonCenterYOffset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias PrivateOptionsView = OptionsView
private extension PrivateOptionsView {
    func activateOptionBtnConstraints (view: UIView, centerYOffset: CGFloat) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYOffset * 2))
        constraints.append(view.heightAnchor.constraint(equalToConstant: optionButtonHeigh))
        constraints.append(view.widthAnchor.constraint(equalToConstant: optionButtonWidth))
        NSLayoutConstraint.activate(constraints)
    }
}

private typealias OptionsViewProtocolImplementation = OptionsView
extension OptionsViewProtocolImplementation: OptionsViewProtocol {
    var horizontalDemoButton: Actionable {
        return internalHorizontalDemoButton
    }
    
    var verticalDemoButton: Actionable {
        return internalVerticalDemoButton
    }
}
