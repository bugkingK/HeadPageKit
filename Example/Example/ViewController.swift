//
//  ViewController.swift
//  Example
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit
import HeadPageKit

class ViewController: HeadPageViewController {
    
    private let controllers: [ChildViewController] = [
        .createInstance(bg: .red),
        .createInstance(bg: .blue),
        .createInstance(bg: .green),
    ]
    
    let menuView: MenuView = .init(parts:
        .normalTextColor(.darkText),
        .normalTextFont(UIFont.systemFont(ofSize: 17)),
        .selectedTextColor(.red),
        .selectedTextFont(UIFont.boldSystemFont(ofSize: 17)),
        .switchStyle(.line),
        .itemSpace(32),
        .sliderStyle(.init(parts: .height(2.0), .position(.bottom), .extraWidth(16.0)))
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuView.titles = ["하나", "둘", "셋"]
        menuView.delegate = self
        menuView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        dataSource = self
    }

}

extension ViewController: HeadPageViewControllerDataSource {
    
    func numberOfViewControllers(in pageController: HeadPageViewController) -> Int {
        return controllers.count
    }
    
    func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return controllers[index]
    }

    func menuViewFor(_ pageController: HeadPageViewController) -> (UIView & MenuViewProtocol)? {
        return menuView
    }

    func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return 50
    }
}

