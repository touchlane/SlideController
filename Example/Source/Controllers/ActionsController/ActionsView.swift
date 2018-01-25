//
//  ActionsView.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class ActionsView: UIView {
    let positionControl = UISegmentedControl(items: [
        NSLocalizedString("BesideSegmentTitle", comment: ""),
        NSLocalizedString("AboveSegmentTitle", comment: "")])
    let removeButton = FilledButton()
    let insertButton = FilledButton()
    let appendButton = FilledButton()
    let menuButton = FilledButton()
    var changePositionAction: ((Int) -> ())?
    
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 32
    private let stackViewSpacing: CGFloat = 20
    private let positionControlWidth: CGFloat = 200
    private let positionControlBackgroundColor = UIColor.purple
    private let positionControlTintColor = UIColor.white
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        activateStackViewConstraints(view: stackView)
        
        positionControl.backgroundColor = positionControlBackgroundColor
        positionControl.tintColor = positionControlTintColor
        positionControl.layer.cornerRadius = 5 // don't let background bleed
        positionControl.selectedSegmentIndex = 0
        positionControl.addTarget(self, action: #selector(positionControlValueChanged(sender:)), for: .valueChanged)
        positionControl.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(positionControl)
        activatePositionControlConstraints(view: positionControl)
        
        removeButton.setTitle("Remove", for: .normal)
        removeButton.clipsToBounds = true
        removeButton.layer.cornerRadius = buttonHeight / 2
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(removeButton)
        activateButtonConstraints(view: removeButton)
        
        insertButton.setTitle("Insert", for: .normal)
        insertButton.clipsToBounds = true
        insertButton.layer.cornerRadius = buttonHeight / 2
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(insertButton)
        activateButtonConstraints(view: insertButton)
        
        appendButton.setTitle("Append", for: .normal)
        appendButton.clipsToBounds = true
        appendButton.layer.cornerRadius = buttonHeight / 2
        appendButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(appendButton)
        activateButtonConstraints(view: appendButton)
        
        menuButton.setTitle("Menu", for: .normal)
        menuButton.clipsToBounds = true
        menuButton.layer.cornerRadius = buttonHeight / 2
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(menuButton)
        activateButtonConstraints(view: menuButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let stackViewPoint = stackView.convert(point, from: self)
        return [removeButton, insertButton, appendButton, menuButton, positionControl]
            .contains { $0.frame.contains(stackViewPoint) }
    }
    
    var isShowAdvancedActions: Bool = true {
        didSet {
            guard oldValue != isShowAdvancedActions else {
                return
            }
            if isShowAdvancedActions {
                stackView.insertArrangedSubview(positionControl, at: 0)
                activatePositionControlConstraints(view: positionControl)
                stackView.insertArrangedSubview(removeButton, at: 1)
                activateButtonConstraints(view: removeButton)
                stackView.insertArrangedSubview(insertButton, at: 2)
                activateButtonConstraints(view: insertButton)
                stackView.insertArrangedSubview(appendButton, at: 3)
                activateButtonConstraints(view: appendButton)
            }
            else {
                positionControl.removeFromSuperview()
                removeButton.removeFromSuperview()
                insertButton.removeFromSuperview()
                appendButton.removeFromSuperview()
            }
        }
    }
}

private typealias PrivateActionsView = ActionsView
private extension PrivateActionsView {
    func activateStackViewConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)])
        
    }
    
    func activateButtonConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: self.buttonWidth),
            view.heightAnchor.constraint(equalToConstant: self.buttonHeight)])
    }
    
    func activatePositionControlConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: self.positionControlWidth),
            view.heightAnchor.constraint(equalToConstant: self.buttonHeight)])
    }
    
    @objc func positionControlValueChanged(sender: UISegmentedControl) {
        changePositionAction?(sender.selectedSegmentIndex)
    }
}
