//
//  TitleItemController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class TitleItemController<T>: TitleItemControllableObject where T: TitleItemObject, T: UIView {
    private var item = T()
    typealias Item = T.Item
    
    // MARK: - InitializableImplementation
    required init() {
        
    }
    
    // MARK: - ItemViewableImplementation
    var view: Item {
        return item.view
    }
    
    // MARK: - SelectableImplementation
    var isSelected: Bool {
        get {
            return item.isSelected
        }
        set {
            item.isSelected = newValue
        }
    }
    
    var didSelectAction: ((Int) -> ())? {
        get {
            return item.didSelectAction
        }
        set {
            item.didSelectAction = newValue
        }
    }
    
    var index: Int {
        get {
            return item.index
        }
        set {
            item.index = newValue
        }
    }
}

