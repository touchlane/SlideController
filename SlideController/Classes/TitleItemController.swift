//
//  TitleItemController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class TitleItemController<T> : TitleItemControllableObject where T : TitleItemObject, T : UIView {

    private var item = T()
    typealias Item = T.Item
    
    //MARK: - Initializable_Implementation
    
    required init() {
        
    }
    
    //MARK: - ItemViewable_Implementation
    
    var view : Item {
        return item.view
    }
    
    //MARK: - Selectable_Implementation
    
    var isSelected : Bool {
        get {
            return item.isSelected
        }
        set {
            item.isSelected = newValue
        }
    }
    
    var didSelectAction : ((Int) -> ())? {
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

