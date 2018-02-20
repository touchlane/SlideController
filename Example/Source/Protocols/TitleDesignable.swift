//
//  TitleDesignable.swift
//  Example
//
//  Created by Pavel Kondrashkov on 2/19/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import Foundation
import UIKit

typealias TitleDesignable = TitleAccessible & TitleColorable

protocol TitleAccessible: class {
    var title: String { get }
}

protocol TitleColorable: class {
    var titleColor: UIColor { get }
}
