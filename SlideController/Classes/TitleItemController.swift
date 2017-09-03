//
//  TitleItemController.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/17/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class TitleItemController<T> : TitleItemControllableObject where T : TitleItemObject, T : UIView {

    private var _item = T()
    typealias Item = T.Item
    
    //MARK: - Initializable_Implementation
    
    required init() {
        
    }
    
    //MARK: - ItemViewable_Implementation
    
    var view : Item {
        return _item.view
    }
    
    //MARK: - Selectable_Implementation
    
    var isSelected : Bool {
        get {
            return _item.isSelected
        }
        set {
            _item.isSelected = newValue
        }
    }
    
    var didSelectAction : ((Int) -> ())? {
        get {
            return _item.didSelectAction
        }
        set {
            _item.didSelectAction = newValue
        }
    }
    
    var index: Int {
        get {
            return _item.index
        }
        set {
            _item.index = newValue
        }
    }
}

