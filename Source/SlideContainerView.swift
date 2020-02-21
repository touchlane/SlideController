//
//  SlideContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

/// Represents container view for one page content
final class SlideContainerView: UIView {
    private var internalView: UIView

    private var oldSize: CGSize = .zero

    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        internalView = view
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        guard oldSize != bounds.size else {
            return
        }

        super.layoutSubviews()

        guard !isHidden else {
            return
        }

        internalView.frame = bounds
        oldSize = bounds.size
    }
}
