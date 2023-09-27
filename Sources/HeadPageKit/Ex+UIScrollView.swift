//
//  Ex+UIScrollView.swift
//  
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

private struct AssociatedKeys {
    static var AMIsCanScroll: Int = 202010261
    static var AMOriginOffset: Int = 202010262
}

extension UIScrollView {
    internal var am_isCanScroll: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.AMIsCanScroll) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AMIsCanScroll, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var am_originOffset: CGPoint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AMOriginOffset) as? CGPoint
        }
        set {
            guard am_originOffset == nil else {
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys.AMOriginOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
