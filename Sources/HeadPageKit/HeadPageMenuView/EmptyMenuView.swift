//
//  EmptyMenuView.swift
//  
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit

class EmptyMenuView: UIView, HeadPageMenuItemProtocol {
    public weak var delegate: TridentMenuViewDelegate?
    
    func updateLayout(_ externalScrollView: UIScrollView) { }
    func checkState(animation: Bool) { }
}
