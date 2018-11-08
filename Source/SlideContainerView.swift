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
    
    private(set) var specHidden: Bool = false
    
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

        guard !self.specHidden else {
            return
        }
        
        self.internalView.frame = self.bounds
        
        self.oldSize = self.bounds.size
    }
    
    ///Sets container view frame width or height to 0,
    ///internal view saves frame size to avoid unnecessary layout work
    func hide(direction: SlideDirection) {
        self.specHidden = true
    }
    
    ///Returns container view frame width or height to match superview frame
    func show(direction: SlideDirection) {
        self.specHidden = false
    }
}

///Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerView
extension ViewableImplementation: Viewable {
    var view: UIView {
        return self
    }
}
