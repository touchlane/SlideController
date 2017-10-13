//
//  OptionsView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol OptionsViewProtocol : class {
    var horizontalDemoBtn: Actionable { get }
    var verticalDemoBtn: Actionable { get }
}

class OptionsView : UIView {
    private let optionBtnWidth: CGFloat = 220
    private let optionBtnHeigh: CGFloat = 32
    private let horizontalDemoBtnCenterYOffset: CGFloat = -16
    private let verticalDemoBtnCenterYOffset: CGFloat = 16
    private let internalHorizontalDemoBtn = FilledButton()
    private let internalVerticalDemoBtn = FilledButton()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black
        internalHorizontalDemoBtn.setTitle("Horizontal Sample", for: UIControlState())
        internalHorizontalDemoBtn.clipsToBounds = true
        internalHorizontalDemoBtn.layer.cornerRadius = optionBtnHeigh / 2
        internalHorizontalDemoBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalHorizontalDemoBtn)
        activateOptionBtnConstraints(view: internalHorizontalDemoBtn, centerYOffset: horizontalDemoBtnCenterYOffset)
        internalVerticalDemoBtn.setTitle("Vertical Sample", for: UIControlState())
        internalVerticalDemoBtn.clipsToBounds = true
        internalVerticalDemoBtn.layer.cornerRadius = optionBtnHeigh / 2
        internalVerticalDemoBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalVerticalDemoBtn)
        activateOptionBtnConstraints(view: internalVerticalDemoBtn, centerYOffset: verticalDemoBtnCenterYOffset)
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
        constraints.append(view.heightAnchor.constraint(equalToConstant: optionBtnHeigh))
        constraints.append(view.widthAnchor.constraint(equalToConstant: optionBtnWidth))
        NSLayoutConstraint.activate(constraints)
    }
}

private typealias OptionsViewProtocolImplementation = OptionsView
extension OptionsViewProtocolImplementation : OptionsViewProtocol {
    var horizontalDemoBtn: Actionable {
        return internalHorizontalDemoBtn
    }
    
    var verticalDemoBtn: Actionable {
        return internalVerticalDemoBtn
    }
}
