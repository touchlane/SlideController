//
//  VerticalContentView.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class VerticalContentView: UIView {
    let menuButton = FilledButton()
    
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 32
    
    init() {
        super.init(frame: CGRect.zero)
        self.menuButton.setTitle("Menu", for: .normal)
        self.menuButton.clipsToBounds = true
        self.menuButton.layer.cornerRadius = self.buttonWidth / 2
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.menuButton)
        self.activateMenuButtonConstraints(view: self.menuButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.menuButton.frame.contains(point) {
            return true
        }
        return false
    }
}

private typealias PrivateVerticalContentView = VerticalContentView
private extension PrivateVerticalContentView {
    func activateMenuButtonConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: self.buttonWidth),
            view.heightAnchor.constraint(equalToConstant: self.buttonHeight)
            ])
    }
}
