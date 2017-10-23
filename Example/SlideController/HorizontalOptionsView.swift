//
//  BottomBarView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class HorizontalOptionsView : UIView {
    let menuBtn = FilledButton()
    let positionControl = UISegmentedControl(items: ["Beside", "Above"])
    var changePositionAction: ((Int) -> ())?
    
    private let btnWidth: CGFloat = 120
    private let btnHeigh: CGFloat = 32
    private let positionControlVerticalOffset: CGFloat = -60
    private let positionControlWidth: CGFloat = 200
    private let positionControlBackgroundColor = UIColor.purple
    private let positionControlTintColor = UIColor.white
    
    init() {
        super.init(frame: CGRect.zero)
        menuBtn.setTitle("Menu", for: UIControlState())
        menuBtn.clipsToBounds = true
        menuBtn.layer.cornerRadius = btnHeigh / 2
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuBtn)
        activateMenuBtnConstraints(view: menuBtn, superView: self)
        positionControl.backgroundColor = positionControlBackgroundColor
        positionControl.tintColor = positionControlTintColor
        positionControl.layer.cornerRadius = 5 // don't let background bleed
        positionControl.selectedSegmentIndex = 0
        positionControl.addTarget(self, action: #selector(positionControlValueChanged(sender:)), for: .valueChanged)
        positionControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(positionControl)
        activatePositionCtrlConstraints(view: positionControl, superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if menuBtn.frame.contains(point) || positionControl.frame.contains(point) {
            return true
        }
        return false
    }
}


private typealias PrivateHorizontalOptionsView = HorizontalOptionsView
private extension PrivateHorizontalOptionsView {
    func activateMenuBtnConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: superView.centerYAnchor))
        constraints.append(view.widthAnchor.constraint(equalToConstant: btnWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: btnHeigh))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activatePositionCtrlConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: positionControlVerticalOffset))
        constraints.append(view.widthAnchor.constraint(equalToConstant: positionControlWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: btnHeigh))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func positionControlValueChanged(sender: UISegmentedControl) {
        changePositionAction?(sender.selectedSegmentIndex)
    }
}
