//
//  ContentPage.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

///Represents container for one page content
final internal class ContentPage {
    
    ///Used internally for pages ordering
    var constraints = [NSLayoutConstraint]()
    fileprivate var intenalView: UIView
    
    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        intenalView = view
    }
}

private typealias ViewableImplementation = ContentPage
extension ViewableImplementation: Viewable {
    var view: UIView {
        return intenalView
    }
}
