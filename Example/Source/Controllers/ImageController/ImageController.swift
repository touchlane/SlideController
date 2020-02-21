//
//  ImageController.swift
//  Example
//
//  Created by Vadim Morozov on 12/28/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import SlideController
import UIKit

class ImageController {
    private let internalView = ImageView()
    var image: UIImage? {
        get {
            internalView.image
        }
        set {
            internalView.image = newValue
        }
    }
}

private typealias ViewableImplementation = ImageController
extension ViewableImplementation: Viewable {
    var view: UIView {
        internalView
    }
}
