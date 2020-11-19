//
//  Ex+UIViewController.swift
//  
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

extension UIViewController {
    
    public var amPageViewContoller: HeadPageViewController? {
        return parent as? HeadPageViewController
    }
    
    func clearFromParent() {
        willMove(toParent: nil)
        beginAppearanceTransition(false, animated: false)
        view.removeFromSuperview()
        endAppearanceTransition()
        removeFromParent()
    }
}
