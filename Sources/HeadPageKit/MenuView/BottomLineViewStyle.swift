//
//  BottomLineViewStyle.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

public enum BottomLineStyle {
    case backgroundColor(UIColor)
    case height(CGFloat)
    case hidden(Bool)
}

public class BottomLineViewStyle {
    
    public var backgroundColor = UIColor.black.withAlphaComponent(0.15) {
        didSet {
            targetView?.backgroundColor = backgroundColor
        }
    }
    
    public var height: CGFloat = 0.5 {
        didSet {
            targetViewHeight?.constant = height
        }
    }
    
    public var hidden = false {
        didSet {
            targetView?.isHidden = hidden
        }
    }
    
    weak var targetView: UIView? {
        didSet {
            targetView?.translatesAutoresizingMaskIntoConstraints = false
            targetView?.backgroundColor = backgroundColor
            targetView?.isHidden = hidden
            targetViewHeight = targetView?.heightAnchor.constraint(equalToConstant: height)
        }
    }
    
    private var targetViewHeight: NSLayoutConstraint?
    public init(view: UIView) {
        targetView = view
    }
    
    public init(parts: BottomLineStyle...) {
        for part in parts {
            switch part {
            case .backgroundColor(let color):
                backgroundColor = color
            case .height(let value):
                height = value
            case .hidden(let value):
                hidden = value
            }
        }
    }

}
