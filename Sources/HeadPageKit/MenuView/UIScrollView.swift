//
//  BottomLineViewStyle.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToSuitablePosition(_ targetView: UIView?, _ animation: Bool) {
        guard contentSize.width + contentInset.left + contentInset.right > bounds.width, let targetView = targetView else {
            return
        }
        let x = min(max(targetView.center.x - frame.midX, 0.0), contentSize.width - bounds.width)
        setContentOffset(CGPoint(x: x, y: 0), animated: animation)
    }
}
