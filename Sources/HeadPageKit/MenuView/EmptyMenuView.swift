//
//  EmptyMenuView.swift
//  
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit

class EmptyMenuView: UIView, MenuViewProtocol {
    public weak var delegate: MenuViewDelegate?
    var titles: [String] = []
    
    func contentScrollViewDidScroll(_ scrollView: UIScrollView) { }
    func didDisplay(_ animation: Bool) { }
}
