//
//  OptionsView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol OptionsViewProtocol : class {
    var horizontalDemoBtn : Actionable { get }
    var verticalDemoBtn : Actionable { get }
}

class OptionsView : UIView {
    fileprivate let _optionBtnWidth : CGFloat = 220
    fileprivate let _optionBtnHeigh : CGFloat = 32
    fileprivate let _horizontalDemoBtnCenterYOffset : CGFloat = -16
    fileprivate let _verticalDemoBtnCenterYOffset : CGFloat = 16
    
    fileprivate let _horizontalDemoBtn = FilledButton()
    fileprivate let _verticalDemoBtn = FilledButton()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black
        _horizontalDemoBtn.setTitle("Horizontal Sample", for: UIControlState())
        _horizontalDemoBtn.clipsToBounds = true
        _horizontalDemoBtn.layer.cornerRadius = _optionBtnHeigh / 2
        _horizontalDemoBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_horizontalDemoBtn)
        activateOptionBtnConstraints(view : _horizontalDemoBtn, centerYOffset: _horizontalDemoBtnCenterYOffset)
        _verticalDemoBtn.setTitle("Vertical Sample", for: UIControlState())
        _verticalDemoBtn.clipsToBounds = true
        _verticalDemoBtn.layer.cornerRadius = _optionBtnHeigh / 2
        _verticalDemoBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_verticalDemoBtn)
        activateOptionBtnConstraints(view : _verticalDemoBtn, centerYOffset : _verticalDemoBtnCenterYOffset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias Private_OptionsView = OptionsView
private extension Private_OptionsView {
    func activateOptionBtnConstraints (view : UIView, centerYOffset : CGFloat) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYOffset*2))
        constraints.append(view.heightAnchor.constraint(equalToConstant: _optionBtnHeigh))
        constraints.append(view.widthAnchor.constraint(equalToConstant: _optionBtnWidth))
        NSLayoutConstraint.activate(constraints)
    }
}

private typealias OptionsViewProtocol_Implementation = OptionsView
extension OptionsViewProtocol_Implementation : OptionsViewProtocol {
    var horizontalDemoBtn : Actionable {
        return _horizontalDemoBtn
    }
    var verticalDemoBtn : Actionable {
        return _verticalDemoBtn
    }
}
