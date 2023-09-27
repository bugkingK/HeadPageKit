//
//  HeadPageProtocol.swift
//  
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

public protocol HeadPageViewControllerDataSource: AnyObject {
    /// You can set up the View where the HeadPage is created. default is the View of the HeadPageView Controller.
    ///
    /// - Parameter pageView: HeadPageView
    /// - Returns: UIView?
    func sourceViewFor(_ pageView: HeadPageView) -> UIView?
    func numberOfViewControllers(in pageView: HeadPageView) -> Int
    func pageView(_ pageView: HeadPageView, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController)
    func headerViewFor(_ pageView: HeadPageView) -> UIView?
    func headerViewHeightFor(_ pageView: HeadPageView) -> CGFloat?
    func menuViewFor(_ pageView: HeadPageView) -> (UIView & MenuViewProtocol)?
    func menuViewTitleFor(_ pageView: HeadPageView) -> [String]
    func menuViewHeightFor(_ pageView: HeadPageView) -> CGFloat?
    func menuViewPinHeightFor(_ pageView: HeadPageView) -> CGFloat

    /// The index of the controller displayed by default. You should have menview ready before setting this value
    ///
    /// - Parameter pageView: HeadPageView
    /// - Returns: Int
    func originIndexFor(_ pageView: HeadPageView) -> Int
    /// Asks the delegate for the margins to apply to content.
    /// - Parameter pageView: HeadPageView
    func contentInsetFor(_ pageView: HeadPageView) -> UIEdgeInsets
}

extension HeadPageViewControllerDataSource {
    public func sourceViewFor(_ pageView: HeadPageView) -> UIView? { return nil }
    public func menuViewPinHeightFor(_ pageView: HeadPageView) -> CGFloat { return 0 }
    public func originIndexFor(_ pageView: HeadPageView) -> Int { return 0 }
    public func contentInsetFor(_ pageView: HeadPageView) -> UIEdgeInsets { return .zero }
    public func headerViewFor(_ pageView: HeadPageView) -> UIView? { return nil }
    public func headerViewHeightFor(_ pageView: HeadPageView) -> CGFloat? { return nil }
    public func menuViewTitleFor(_ pageView: HeadPageView) -> [String] { return [] }
}

public protocol HeadPageViewControllerDelegate: AnyObject {
    
    /// Any offset changes in pageView's mainScrollView
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - scrollView: mainScrollView
    func pageView(_ pageView: HeadPageView, mainScrollViewDidScroll scrollView: UIScrollView)
   
    
    /// Method call when contentScrollView did end scroll
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - scrollView: contentScrollView
    func pageView(_ pageView: HeadPageView, contentScrollViewDidEndScroll scrollView: UIScrollView)
    
    
    /// Any offset changes in pageView's contentScrollView
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - scrollView: contentScrollView
    func pageView(_ pageView: HeadPageView, contentScrollViewDidScroll scrollView: UIScrollView)
    
    /// Method call when viewController will cache
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageView(_ pageView: HeadPageView, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when viewController will display
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageView(_ pageView: HeadPageView, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when viewController did display
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageView(_ pageView: HeadPageView, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when menuView is adsorption
    ///
    /// - Parameters:
    ///   - pageView: HeadPageView
    ///   - isAdsorption: is adsorption
    func pageView(_ pageView: HeadPageView, menuView isAdsorption: Bool)
    
    func pageView(_ pageView: HeadPageView, menuView: MenuView, didSelectedItemAt index: Int)
}

extension HeadPageViewControllerDelegate {
    public func pageView(_ pageView: HeadPageView, mainScrollViewDidScroll scrollView: UIScrollView) { }
    public func pageView(_ pageView: HeadPageView, contentScrollViewDidEndScroll scrollView: UIScrollView) { }
    public func pageView(_ pageView: HeadPageView, contentScrollViewDidScroll scrollView: UIScrollView) { }
    public func pageView(_ pageView: HeadPageView, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageView(_ pageView: HeadPageView, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageView(_ pageView: HeadPageView, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageView(_ pageView: HeadPageView, menuView isAdsorption: Bool) { }
    public func pageView(_ pageView: HeadPageView, menuView: MenuView, didSelectedItemAt index: Int) { }
}
