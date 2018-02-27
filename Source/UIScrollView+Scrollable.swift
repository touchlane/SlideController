//
//  UIScrollView+Scrollable.swift
//  SlideController
//
//  Created by Vadim Morozov on 2/27/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

extension UIScrollView {
    private var scrollAnimationDuration: TimeInterval { return 0.25 }
    
    func scroll(to contentOffset: CGPoint, animated: Bool) {
        if animated {
            UIView.animate(withDuration: self.scrollAnimationDuration, animations: {
                self.contentOffset = contentOffset
            })
        }
        else {
            self.setContentOffset(contentOffset, animated: false)
        }
    }
}
