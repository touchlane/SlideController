//
//  MainRouter.swift
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
        optionsControler.openHorizontalDemoAction = self.openHorizontalDemoAction
        optionsControler.openVerticalDemoAction = self.openVerticalDemoAction
        let vc = ContentUIViewController<OptionsController>()
        vc.controller = optionsControler
        self.presenter?.setViewControllers([vc], animated: animated)
    }
    
    func showMainPage(animated: Bool) {
        let optionsController = HorizontalOptionsController()
        optionsController.menuDidTapAction = self.menuDidTapAction
        let mainController = MainController()
        mainController.optionsController = optionsController
        let vc = LifecycleContentUIViewController<MainController>()
        vc.controller = mainController
        self.presenter?.pushViewController(vc, animated: animated)
    }
    
    func showVerticalPage(animated: Bool) {
        let optionsController = HorizontalOptionsController()
        optionsController.menuDidTapAction = self.menuDidTapAction
        let mainController = VerticalController()
        mainController.optionsController = optionsController
        let vc = LifecycleContentUIViewController<MainController>()
        vc.controller = mainController
    }
    
    private lazy var openHorizontalDemoAction: (() -> Void)? = { [weak self] in
        guard let `self` = self else { return }
        self.showMainPage(animated: true)
    }
    
    private lazy var openVerticalDemoAction: (() -> Void)? = { [weak self] in
        guard let `self` = self else { return }
        self.showVerticalPage(animated: true)
    }
    
    private lazy var menuDidTapAction: (() -> Void)? = { [weak self] in
        guard let `self` = self else { return }
        self.presenter?.popViewController(animated: true)
    }
}
