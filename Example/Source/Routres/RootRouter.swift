//
//  RootRouter.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class RootRouter {
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func openMainScreen(animated: Bool) {
        let optionsControler = OptionsController()
        optionsControler.openHorizontalDemoAction = openHorizontalDemoAction
        optionsControler.openVerticalDemoAction = openVerticalDemoAction
        optionsControler.openCircularDemoAction = openCircularDemoAction
        let vc = ContentUIViewController<OptionsController>()
        vc.controller = optionsControler
        setupNavigationBar(presenter: presenter, controller: optionsControler)
        presenter.setViewControllers([vc], animated: animated)
    }
    
    func showHorizontalPage(animated: Bool) {
        let actionsController = ActionsController()
        let horizontalController = HorizontalController()
        horizontalController.optionsController = actionsController
        let vc = LifecycleContentUIViewController<HorizontalController>()
        vc.controller = horizontalController
        setupNavigationBar(presenter: presenter, controller: horizontalController)
        presenter.pushViewController(vc, animated: animated)
    }
    
    func showVerticalPage(animated: Bool) {
        let actionsController = ActionsController()
        let verticalController = VerticalController()
        verticalController.optionsController = actionsController
        let lifecycleController = LifecycleContentUIViewController<VerticalController>()
        lifecycleController.controller = verticalController
        setupNavigationBar(presenter: presenter, controller: verticalController)
        presenter.pushViewController(lifecycleController, animated: animated)
    }
    
    func showCircularPage(animated: Bool) {
        let actionsController = ActionsController()
        actionsController.isShowAdvancedActions = false
        let circularController = CircularController()
        circularController.optionsController = actionsController
        let lifecycleController = LifecycleContentUIViewController<CircularController>()
        lifecycleController.controller = circularController
        setupNavigationBar(presenter: presenter, controller: circularController)
        presenter.pushViewController(lifecycleController, animated: animated)
    }
    
    private lazy var openHorizontalDemoAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.showHorizontalPage(animated: true)
    }
    
    private lazy var openVerticalDemoAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else {
            return
        }
        strongSelf.showVerticalPage(animated: true)
    }
    
    private lazy var openCircularDemoAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else {
            return
        }
        strongSelf.showCircularPage(animated: true)
    }
    
    private func setupNavigationBar(presenter: UINavigationController, controller: TitleDesignable) {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowColor = UIColor(white: 0.5, alpha: 0.5)
        
        presenter.navigationBar.tintColor = controller.titleColor
        presenter.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: controller.titleColor,
            NSAttributedStringKey.shadow: shadow
        ]
    }
}
