//
//  TEstInternalView.swift
//  SlideController
//
//  Created by Vasileuski Vadzim on 11/6/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import Foundation

class TEstInternalView: UIView {
    private var oldSize: CGSize = .zero
    
    override func layoutSubviews() {
        guard self.oldSize != self.bounds.size else {
            return
        }
        super.layoutSubviews()
        
        self.subviews.first?.frame = self.bounds
        self.oldSize = self.bounds.size
    }
}
