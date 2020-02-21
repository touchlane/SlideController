//
//  ScrollContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class SlideView<T>: UIView, TitleViewConfigurationDelegate where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable {
    private var oldSize: CGSize = .zero

    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                addSubview(view)
            }
            layoutContainers()
        }
    }

    var titleView: T? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = self.titleView {
                view.titleViewConfigurationDelegate = self
                self.addSubview(view)
            }
            self.layoutContainers()
        }
    }

    override func layoutSubviews() {
        guard bounds.size != oldSize else {
            return
        }

        super.layoutSubviews()
        layoutContainers()
        oldSize = bounds.size
    }

    private func layoutContainers() {
        if let titleView = self.titleView {
            let alignment = titleView.alignment
            let size = titleView.titleSize
            titleView.frame = titleFrame(in: bounds, alignment: alignment, size: size)

            if titleView.position == TitleViewPosition.beside {
                contentView?.frame = contentFrame(in: bounds, alignment: alignment, size: size)
            } else {
                contentView?.frame = bounds
            }
        } else {
            contentView?.frame = bounds
        }
    }

    private func titleFrame(in bounds: CGRect, alignment: TitleViewAlignment, size: CGFloat) -> CGRect {
        switch alignment {
        case .top:
            return CGRect(x: 0, y: 0, width: bounds.width, height: size)
        case .bottom:
            return CGRect(x: 0, y: bounds.height - size, width: bounds.width, height: size)
        case .left:
            return CGRect(x: 0, y: 0, width: size, height: bounds.height)
        case .right:
            return CGRect(x: bounds.width - size, y: 0, width: size, height: bounds.height)
        }
    }

    private func contentFrame(in bounds: CGRect, alignment: TitleViewAlignment, size: CGFloat) -> CGRect {
        switch alignment {
        case .top:
            return CGRect(x: 0, y: size, width: bounds.width, height: bounds.height - size)
        case .bottom:
            return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - size)
        case .left:
            return CGRect(x: size, y: 0, width: bounds.width - size, height: bounds.height)
        case .right:
            return CGRect(x: 0, y: 0, width: bounds.width - size, height: bounds.height)
        }
    }

    // MARK: - TitleViewConfigurationDelegateImplementation

    func didChangeAlignment(alignment: TitleViewAlignment) {
        layoutContainers()
    }

    func didChangeTitleSize(size: CGFloat) {
        if titleView != nil {
            layoutContainers()
        }
    }

    func didChangePosition(position: TitleViewPosition) {
        layoutContainers()
    }
}
