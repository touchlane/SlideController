//
//  MainRouter.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class RootRouter {
    var presenter : UINavigationController?
    
    func showSignIn(animated : Bool) {
        let signInControler = SignInController()
        signInControler.signInDidTapAction = signInDidTapAction
        let vc = ContentUIViewController<SignInController>(controller: signInControler)
        presenter?.setViewControllers([vc], animated: animated)
    }
    
    func showMainPage(animated : Bool) {
        let logoutController = LogoutController()
        logoutController.logOutDidTapAction = logOutDidTapAction
        let mainController = MainController()
        mainController.bottomController = logoutController
        let vc = LifecycleContentUIViewController<MainController>(controller: mainController)
        presenter?.setViewControllers([vc], animated: animated)
    }
    
    private lazy var signInDidTapAction : (() -> ())? = { [weak self] in
        guard let `self` = self else { return }
        self.showMainPage(animated : true)
    }
    
    private lazy var logOutDidTapAction : (() -> ())? = { [weak self] in
        guard let `self` = self else { return }
        self.showSignIn(animated : true)
    }
}
