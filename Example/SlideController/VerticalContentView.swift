//
//  VerticalContentView.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class VerticalContentView: UIView {
    
    let removeButton = FilledButton()
    let insertButton = FilledButton()
    let menuButton = FilledButton()
    
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 32
    private let buttonVerticalOffset: CGFloat = 40
    
    init() {
        super.init(frame: CGRect.zero)
        
        removeButton.setTitle("Remove", for: .normal)
        removeButton.clipsToBounds = true
        removeButton.layer.cornerRadius = buttonHeight / 2
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(removeButton)
        activateRemoveButtonConstraints(view: removeButton)
        
        insertButton.setTitle("Insert", for: .normal)
        insertButton.clipsToBounds = true
        insertButton.layer.cornerRadius = buttonHeight / 2
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(insertButton)
        activateInsertButtonConstraints(view: insertButton)
        
        menuButton.setTitle("Menu", for: .normal)
        menuButton.clipsToBounds = true
        menuButton.layer.cornerRadius = buttonHeight / 2
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuButton)
        activateMenuButtonConstraints(view: menuButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return [removeButton, insertButton, menuButton]
            .contains { $0.frame.contains(point) }
    }
}

private typealias PrivateVerticalContentView = VerticalContentView
private extension PrivateVerticalContentView {
    
    func activateRemoveButtonConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: -(buttonVerticalOffset * 2)),
            view.widthAnchor.constraint(equalToConstant: self.buttonWidth),
            view.heightAnchor.constraint(equalToConstant: self.buttonHeight)
            ])
    }
    
    func activateInsertButtonConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: buttonVerticalOffset),
            view.widthAnchor.constraint(equalToConstant: buttonWidth),
            view.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
    }
    
    func activateMenuButtonConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.topAnchor.constraint(equalTo: insertButton.bottomAnchor, constant: buttonVerticalOffset),
            view.widthAnchor.constraint(equalToConstant: buttonWidth),
            view.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
    }
}
