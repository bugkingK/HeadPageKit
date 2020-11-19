//
//  HeadPageMainScrollView.swift
//  
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

public class HeadPageMainScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var headerViewHeight: CGFloat = 0.0
    var menuViewHeight: CGFloat = 0.0
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        scrollsToTop = true
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let scrollView = gestureRecognizer.view as? UIScrollView else {
            return false
        }
        
        let offsetY = headerViewHeight + menuViewHeight
        let contentSize = scrollView.contentSize
        let targetRect = CGRect(x: 0,
                                y: offsetY - UIApplication.shared.statusBarFrame.height,
                                width: contentSize.width,
                                height: contentSize.height - offsetY)
        
        let currentPoint = gestureRecognizer.location(in: self)
        return targetRect.contains(currentPoint)
    }
}
