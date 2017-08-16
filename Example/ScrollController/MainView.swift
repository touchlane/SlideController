//
//  MainView.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import SnapKit

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
        view.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-MainView.bottomViewHeight)
        }
    }
    
    func activateBottomViewConstraints(view : UIView) {
        view.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(MainView.bottomViewHeight)
        }
    }
}

