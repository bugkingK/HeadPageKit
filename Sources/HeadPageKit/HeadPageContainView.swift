//
//  HeadPageContainView.swift
//  
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

class HeadPageContainView: UIView {
    weak var viewController: (UIViewController & HeadPageChildViewController)?
    var isEmpty: Bool {
        return subviews.isEmpty
    }
    
    func displayingIn(view: UIView, containView: UIView) -> Bool {
        let convertedFrame = containView.convert(frame, to: view)
        return view.frame.intersects(convertedFrame)
    }
}


