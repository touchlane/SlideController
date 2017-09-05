//
//  MainView.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class MainView : UIView {
    
    static let bottomViewHeight : CGFloat = 50
    
    var contentView : UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateContentViewConstraints(view: view)
            }
        }
    }
   
    var bottomView : UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = bottomView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateBottomViewConstraints(view: view)
            }
        }
    }
    
}

private typealias Private_MainView = MainView
private extension Private_MainView {
    func activateContentViewConstraints(view : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -MainView.bottomViewHeight))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateBottomViewConstraints(view : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.heightAnchor.constraint(equalToConstant: MainView.bottomViewHeight))
        NSLayoutConstraint.activate(constraints)
    }
}

