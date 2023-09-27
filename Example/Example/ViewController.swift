//
//  ViewController.swift
//  Example
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit
import HeadPageKit

class ViewController: UIViewController {
    @IBOutlet private weak var pageView: HeadPageViewController!
    
    private let models: [(title: String, controller: ChildViewController)] = [
        ("하나", .createInstance(bg: .red)),
        ("둘", .createInstance(bg: .blue)),
        ("셋", .createInstance(bg: .green)),
    ]
    
    let menuView: MenuView = .init(parts:
        .normalTextColor(.darkText),
        .normalTextFont(UIFont.systemFont(ofSize: 17)),
        .selectedTextColor(.red),
        .selectedTextFont(UIFont.boldSystemFont(ofSize: 17)),
        .switchStyle(.line),
        .itemSpace(32),
        .contentInset(UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)),
        .sliderStyle(.init(parts: .height(2.0), .position(.bottom), .extraWidth(16.0)))
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageView.dataSource = self
        pageView.delegate = self
    }

}

extension ViewController: HeadPageViewControllerDataSource {
    
    func numberOfViewControllers(in pageController: HeadPageViewController) -> Int {
        return models.count
    }
    
    func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return models[index].controller
    }

    func menuViewFor(_ pageController: HeadPageViewController) -> (UIView & MenuViewProtocol)? {
        return menuView
    }
    
    func menuViewTitleFor(_ pageController: HeadPageViewController) -> [String] {
        return models.map { $0.title }
    }

    func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return 50
    }
    
    func menuViewPinHeightFor(_ pageController: HeadPageViewController) -> CGFloat {
        return 0
    }
    
    func headerViewFor(_ pageController: HeadPageViewController) -> UIView? {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }
    
    func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return 20
    }
}

extension ViewController: HeadPageViewControllerDelegate {
    
    func pageController(_ pageController: HeadPageViewController, menuView: MenuView, didSelectedItemAt index: Int) {
        print(index)
    }
}
