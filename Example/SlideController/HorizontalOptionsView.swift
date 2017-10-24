//
//  BottomBarView.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class HorizontalOptionsView : UIView {
    let positionControl = UISegmentedControl(items: [
        NSLocalizedString("BesideSegmentTitle", comment: ""),
        NSLocalizedString("AboveSegmentTitle", comment: "")])
    let insertButton = FilledButton()
    let removeButton = FilledButton()
    let appendButton = FilledButton()
    let menuButton = FilledButton()
    
    var changePositionAction: ((Int) -> ())?
    
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 32
    private let positionControlWidth: CGFloat = 200
    private let positionControlBackgroundColor = UIColor.purple
    private let positionControlTintColor = UIColor.white
    
    init() {
        super.init(frame: CGRect.zero)
        removeButton.setTitle(NSLocalizedString("RemoveButtonTitle", comment: ""), for: .normal)
        removeButton.clipsToBounds = true
        removeButton.layer.cornerRadius = buttonHeight / 2
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(removeButton)
        activateRemoveButtonConstraints(view: removeButton, superView: self)
        appendButton.setTitle(NSLocalizedString("AppendButtonTitle", comment: ""), for: .normal)
        appendButton.clipsToBounds = true
        appendButton.layer.cornerRadius = buttonHeight / 2
        appendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(appendButton)
        activateAppendButtonConstraints(view: appendButton, superView: self)
        menuButton.setTitle(NSLocalizedString("MenuButtonTitle", comment: ""), for: .normal)
        menuButton.clipsToBounds = true
        menuButton.layer.cornerRadius = buttonHeight / 2
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuButton)
        activateMenuButtonConstraints(view: menuButton, superView: self)
        insertButton.setTitle(NSLocalizedString("InsertButtonTitle", comment: ""), for: .normal)
        insertButton.clipsToBounds = true
        insertButton.layer.cornerRadius = buttonHeight / 2
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(insertButton)
        activateInsertButtonConstraints(view: insertButton, superView: self)
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
        if menuButton.frame.contains(point) ||
            insertButton.frame.contains(point) ||
            removeButton.frame.contains(point) ||
            appendButton.frame.contains(point) ||
            positionControl.frame.contains(point) {
            return true
        }
        return false
    }
}


private typealias PrivateHorizontalOptionsView = HorizontalOptionsView
private extension PrivateHorizontalOptionsView {
    func activateMenuButtonConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: appendButton.bottomAnchor, constant: buttonHeight / 2))
        constraints.append(view.widthAnchor.constraint(equalToConstant: buttonWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: buttonHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateRemoveButtonConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: buttonHeight))
        constraints.append(view.widthAnchor.constraint(equalToConstant: buttonWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: buttonHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateAppendButtonConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: buttonHeight / 2))
        constraints.append(view.widthAnchor.constraint(equalToConstant: buttonWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: buttonHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateInsertButtonConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -buttonHeight / 2))
        constraints.append(view.widthAnchor.constraint(equalToConstant: buttonWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: buttonHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    func activatePositionCtrlConstraints(view: UIView, superView: UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: insertButton.topAnchor, constant: -buttonHeight / 2))
        constraints.append(view.widthAnchor.constraint(equalToConstant: positionControlWidth))
        constraints.append(view.heightAnchor.constraint(equalToConstant: buttonHeight))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func positionControlValueChanged(sender: UISegmentedControl) {
        changePositionAction?(sender.selectedSegmentIndex)
    }
}
