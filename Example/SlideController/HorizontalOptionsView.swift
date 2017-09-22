//
//  BottomBarView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class HorizontalOptionsView : UIView {
    let logOutBtn = FilledButton()
    
    fileprivate let _logOutInBtnWidth : CGFloat = 120
    fileprivate let _logOutBtnHeigh : CGFloat = 32
    
    init() {
        super.init(frame: CGRect.zero)
        logOutBtn.setTitle("Menu", for: UIControlState())
        logOutBtn.clipsToBounds = true
        logOutBtn.layer.cornerRadius = _logOutBtnHeigh / 2
        logOutBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logOutBtn)
        activateLogOutBtnConstraints(view : logOutBtn, superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if logOutBtn.frame.contains(point) {
            return true
        }
        return false
    }
}


private typealias Private_HorizontalOptionsView = HorizontalOptionsView
private extension Private_HorizontalOptionsView {
    func activateLogOutBtnConstraints (view : UIView, superView : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: superView.centerYAnchor))
        constraints.append(view.widthAnchor.constraint(equalToConstant: _logOutInBtnWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: _logOutBtnHeigh))
        NSLayoutConstraint.activate(constraints)
    }
}
