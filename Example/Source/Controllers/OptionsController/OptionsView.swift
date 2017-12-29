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
    var circularDemoButton: Actionable { get }
}

class OptionsView: UIView {
    private let optionButtonWidth: CGFloat = 220
    private let optionButtonHeigh: CGFloat = 32
    private let horizontalDemoButtonCenterYOffset: CGFloat = -32
    private let verticalDemoButtonCenterYOffset: CGFloat = 0
    private let circularDemoButtonCenterYOffset: CGFloat = 32
    private let internalHorizontalDemoButton = FilledButton()
    private let internalVerticalDemoButton = FilledButton()
    private let internalCircularDemoButton = FilledButton()
    private let copyrightLabel = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        
        internalHorizontalDemoButton.setTitle(NSLocalizedString("HorizontalSampleButtonTitle", comment: ""), for: .normal)
        internalHorizontalDemoButton.clipsToBounds = true
        internalHorizontalDemoButton.layer.cornerRadius = optionButtonHeigh / 2
        internalHorizontalDemoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalHorizontalDemoButton)
        activateOptionButtonConstraints(view: internalHorizontalDemoButton, centerYOffset: horizontalDemoButtonCenterYOffset)
        
        internalVerticalDemoButton.setTitle(NSLocalizedString("VerticalSampleButtonTitle", comment: ""), for: .normal)
        internalVerticalDemoButton.clipsToBounds = true
        internalVerticalDemoButton.layer.cornerRadius = optionButtonHeigh / 2
        internalVerticalDemoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalVerticalDemoButton)
        activateOptionButtonConstraints(view: internalVerticalDemoButton, centerYOffset: verticalDemoButtonCenterYOffset)
        
        internalCircularDemoButton.setTitle(NSLocalizedString("CircularSampleButtonTitle", comment: ""), for: .normal)
        internalCircularDemoButton.clipsToBounds = true
        internalCircularDemoButton.layer.cornerRadius = optionButtonHeigh / 2
        internalCircularDemoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalCircularDemoButton)
        activateOptionButtonConstraints(view: internalCircularDemoButton, centerYOffset: circularDemoButtonCenterYOffset)

        copyrightLabel.text = NSLocalizedString("CopyrightText", comment: "")
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(copyrightLabel)
        activateCopyrightLabelConstraints(view: copyrightLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias PrivateOptionsView = OptionsView
private extension PrivateOptionsView {
    func activateOptionButtonConstraints (view: UIView, centerYOffset: CGFloat) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: centerYOffset * 2),
            view.heightAnchor.constraint(equalToConstant: optionButtonHeigh),
            view.widthAnchor.constraint(equalToConstant: optionButtonWidth)
            ])
    }
    
    func activateCopyrightLabelConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20)
            ])
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
    
    var circularDemoButton: Actionable {
        return internalCircularDemoButton
    }
}
