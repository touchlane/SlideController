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
        optionsControler.openHorizontalDemoAction = openHorizontalDemoAction
        let vc = ContentUIViewController<OptionsController>()
        vc.controller = optionsControler
        presenter?.setViewControllers([vc], animated: animated)
    }
    
    func showMainPage(animated: Bool) {
        let optionsController = HorizontalOptionsController()
        optionsController.menuDidTapAction = menuDidTapAction
        let mainController = MainController()
        optionsController.changePositionAction = mainController.changePositionAction
        mainController.optionsController = optionsController
        let vc = LifecycleContentUIViewController<MainController>()
        vc.controller = mainController
        presenter?.pushViewController(vc, animated: animated)
    }
    
    private lazy var openHorizontalDemoAction: (() -> ())? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.showMainPage(animated: true)
    }
    
    private lazy var menuDidTapAction: (() -> ())? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.presenter?.popViewController(animated: true)
    }
}
