//
//  SlideContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

///Represents container view for one page content
final class SlideContainerView: UIView {
    private var internalView: UIView
    
    private var oldSize: CGSize = .zero

    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        self.internalView = view
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        guard self.oldSize != self.bounds.size else {
            return
        }
        
        super.layoutSubviews()

        guard !self.isHidden else {
            return
        }
        
        self.internalView.frame = self.bounds
        self.oldSize = self.bounds.size
    }
}
