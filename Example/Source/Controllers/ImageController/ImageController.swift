//
//  ImageController.swift
//  Example
//
//  Created by Vadim Morozov on 12/28/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class ImageController {
    private let internalView = ImageView()
}

private typealias ViewableImplementation = ImageController
extension ViewableImplementation: Viewable {
    var view: UIView {
        return internalView
    }
}
