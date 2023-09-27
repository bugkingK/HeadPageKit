//
//  ViewController.swift
//  Example
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit
import HeadPageKit

class ViewController: UIViewController {
    @IBOutlet private weak var pageView: HeadPageView!
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.pageView.move(to: .tip)
        })
        
    }

}

extension ViewController: HeadPageViewControllerDataSource {
    
    func numberOfViewControllers(in pageView: HeadPageView) -> Int {
        return models.count
    }
    
    func pageView(_ pageView: HeadPageView, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return models[index].controller
    }

    func menuViewFor(_ pageView: HeadPageView) -> (UIView & MenuViewProtocol)? {
        return menuView
    }
    
    func menuViewTitleFor(_ pageView: HeadPageView) -> [String] {
        return models.map { $0.title }
    }

    func menuViewHeightFor(_ pageView: HeadPageView) -> CGFloat? {
        return 50
    }
    
    func menuViewPinHeightFor(_ pageView: HeadPageView) -> CGFloat {
        return 0
    }
    
    func headerViewFor(_ pageView: HeadPageView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }
    
    func headerViewHeightFor(_ pageView: HeadPageView) -> CGFloat? {
        return 20
    }
}

extension ViewController: HeadPageViewControllerDelegate {
    
    func pageView(_ pageView: HeadPageView, menuView: MenuView, didSelectedItemAt index: Int) {
        print(index)
    }
}
