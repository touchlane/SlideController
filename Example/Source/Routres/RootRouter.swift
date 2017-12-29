//
//  RootRouter.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class RootRouter {
    var presenter: UINavigationController?
    
    func openMainScreen(animated: Bool) {
        let optionsControler = OptionsController()
        optionsControler.openHorizontalDemoAction = openHorizontalDemoAction
        optionsControler.openVerticalDemoAction = openVerticalDemoAction
        optionsControler.openCircularDemoAction = openCircularDemoAction
        let vc = ContentUIViewController<OptionsController>()
        vc.controller = optionsControler
        presenter?.setViewControllers([vc], animated: animated)
    }
    
    func showHorizontalPage(animated: Bool) {
        let actionsController = ActionsController()
        actionsController.menuDidTapAction = menuDidTapAction
        let horizontalController = HorizontalController()
        horizontalController.optionsController = actionsController
        let vc = LifecycleContentUIViewController<HorizontalController>()
        vc.controller = horizontalController
        presenter?.pushViewController(vc, animated: animated)
    }
    
    func showVerticalPage(animated: Bool) {
        let actionsController = ActionsController()
        actionsController.menuDidTapAction = menuDidTapAction
        let verticalController = VerticalController()
        verticalController.optionsController = actionsController
        let lifecycleController = LifecycleContentUIViewController<VerticalController>()
        lifecycleController.controller = verticalController
        presenter?.pushViewController(lifecycleController, animated: true)
    }
    
    func showCircularPage(animated: Bool) {
        let actionsController = ActionsController()
        actionsController.isShowAdvancedActions = false
        actionsController.menuDidTapAction = menuDidTapAction
        let circularController = CircularController()
        circularController.optionsController = actionsController
        let lifecycleController = LifecycleContentUIViewController<CircularController>()
        lifecycleController.controller = circularController
        presenter?.pushViewController(lifecycleController, animated: true)
    }
    
    private lazy var openHorizontalDemoAction: (() -> ())? = { [weak self] in
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
    
    private lazy var menuDidTapAction: (() -> ())? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.presenter?.popViewController(animated: true)
    }
}
