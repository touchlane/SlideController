//
//  ContentViewModel.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ContentPage {
    var constraints = [NSLayoutConstraint]()
    fileprivate var intenalView : UIView
    
    init(view : UIView) {
        intenalView = view
    }
}

private typealias Viewable_Implementation = ContentPage
extension Viewable_Implementation : Viewable {
    var view : UIView {
        return intenalView
    }
}
