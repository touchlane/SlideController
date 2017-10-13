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
    
    private let btnWidth: CGFloat = 120
    private let btnHeigh: CGFloat = 32
    
    init() {
        super.init(frame: CGRect.zero)
        menuBtn.setTitle("Menu", for: UIControlState())
        menuBtn.clipsToBounds = true
        menuBtn.layer.cornerRadius = btnHeigh / 2
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuBtn)
        activateMenuBtnConstraints(view: menuBtn, superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if menuBtn.frame.contains(point) {
            return true
        }
        return false
    }
}


private typealias PrivateHorizontalOptionsView = HorizontalOptionsView
private extension PrivateHorizontalOptionsView {
    func activateMenuBtnConstraints (view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: superView.centerYAnchor))
        constraints.append(view.widthAnchor.constraint(equalToConstant: btnWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: btnHeigh))
        NSLayoutConstraint.activate(constraints)
    }
}
