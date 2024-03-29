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
    /// - Parameter pageController: HeadPageViewController
    /// - Returns: UIView?
    func sourceViewFor(_ pageController: HeadPageViewController) -> UIView?
    func numberOfViewControllers(in pageController: HeadPageViewController) -> Int
    func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController)
    func headerViewFor(_ pageController: HeadPageViewController) -> UIView?
    func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat?
    func menuViewFor(_ pageController: HeadPageViewController) -> (UIView & MenuViewProtocol)?
    func menuViewTitleFor(_ pageController: HeadPageViewController) -> [String]
    func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat?
    func menuViewPinHeightFor(_ pageController: HeadPageViewController) -> CGFloat

    /// The index of the controller displayed by default. You should have menview ready before setting this value
    ///
    /// - Parameter pageController: HeadPageViewController
    /// - Returns: Int
    func originIndexFor(_ pageController: HeadPageViewController) -> Int
    /// Asks the delegate for the margins to apply to content.
    /// - Parameter pageController: HeadPageViewController
    func contentInsetFor(_ pageController: HeadPageViewController) -> UIEdgeInsets
}

extension HeadPageViewControllerDataSource {
    public func sourceViewFor(_ pageController: HeadPageViewController) -> UIView? { return nil }
    public func menuViewPinHeightFor(_ pageController: HeadPageViewController) -> CGFloat { return 0 }
    public func originIndexFor(_ pageController: HeadPageViewController) -> Int { return 0 }
    public func contentInsetFor(_ pageController: HeadPageViewController) -> UIEdgeInsets { return .zero }
    public func headerViewFor(_ pageController: HeadPageViewController) -> UIView? { return nil }
    public func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? { return nil }
    public func menuViewTitleFor(_ pageController: HeadPageViewController) -> [String] { return [] }
}

public protocol HeadPageViewControllerDelegate: AnyObject {
    
    /// Any offset changes in pageController's mainScrollView
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - scrollView: mainScrollView
    func pageController(_ pageController: HeadPageViewController, mainScrollViewDidScroll scrollView: UIScrollView)
   
    
    /// Method call when contentScrollView did end scroll
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - scrollView: contentScrollView
    func pageController(_ pageController: HeadPageViewController, contentScrollViewDidEndScroll scrollView: UIScrollView)
    
    
    /// Any offset changes in pageController's contentScrollView
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - scrollView: contentScrollView
    func pageController(_ pageController: HeadPageViewController, contentScrollViewDidScroll scrollView: UIScrollView)
    
    /// Method call when viewController will cache
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageController(_ pageController: HeadPageViewController, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when viewController will display
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageController(_ pageController: HeadPageViewController, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when viewController did display
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - viewController: target viewController
    ///   - index: target viewController's index
    func pageController(_ pageController: HeadPageViewController, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int)
    
    
    /// Method call when menuView is adsorption
    ///
    /// - Parameters:
    ///   - pageController: HeadPageViewController
    ///   - isAdsorption: is adsorption
    func pageController(_ pageController: HeadPageViewController, menuView isAdsorption: Bool)
    
    func pageController(_ pageController: HeadPageViewController, menuView: MenuView, didSelectedItemAt index: Int)
}

extension HeadPageViewControllerDelegate {
    public func pageController(_ pageController: HeadPageViewController, mainScrollViewDidScroll scrollView: UIScrollView) { }
    public func pageController(_ pageController: HeadPageViewController, contentScrollViewDidEndScroll scrollView: UIScrollView) { }
    public func pageController(_ pageController: HeadPageViewController, contentScrollViewDidScroll scrollView: UIScrollView) { }
    public func pageController(_ pageController: HeadPageViewController, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageController(_ pageController: HeadPageViewController, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageController(_ pageController: HeadPageViewController, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) { }
    public func pageController(_ pageController: HeadPageViewController, menuView isAdsorption: Bool) { }
    public func pageController(_ pageController: HeadPageViewController, menuView: MenuView, didSelectedItemAt index: Int) { }
}
