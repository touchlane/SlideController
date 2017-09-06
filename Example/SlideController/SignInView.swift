//
//  SignInView.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class SignInView : UIView {
    fileprivate let _signInBtnWidth : CGFloat = 120
    fileprivate let _signInBtnHeigh : CGFloat = 32
    
    let signInBtn = FilledButton()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.red
        signInBtn.setTitle("Sign In", for: UIControlState())
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = _signInBtnHeigh / 2
        signInBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(signInBtn)
        activateSignInBtnConstraints(view : signInBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias Private_SignInView = SignInView
private extension Private_SignInView {
    func activateSignInBtnConstraints (view : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(view.heightAnchor.constraint(equalToConstant: _signInBtnHeigh))
        constraints.append(view.widthAnchor.constraint(equalToConstant: _signInBtnWidth))
        NSLayoutConstraint.activate(constraints)
    }
}

