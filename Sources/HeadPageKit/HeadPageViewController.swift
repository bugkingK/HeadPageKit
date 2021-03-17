//
//  HeadPageViewController.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

open class HeadPageViewController: UIViewController {

    @IBOutlet private(set) weak var sourceView: UIView?

    public private(set) var currentViewController: (UIViewController & HeadPageChildViewController)?
    public private(set) var currentIndex = 0
    internal var originIndex = 0

    lazy public private(set) var mainScrollView: HeadPageMainScrollView = {
        let scrollView = HeadPageMainScrollView()
        scrollView.delegate = self
        scrollView.am_isCanScroll = true
        return scrollView
    }()

    lazy internal var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if let popGesture = navigationController?.interactivePopGestureRecognizer {
            scrollView.panGestureRecognizer.require(toFail: popGesture)
        }
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var contentScrollViewConstraint: NSLayoutConstraint?
    private var menuViewConstraint: NSLayoutConstraint?
    internal var headerViewConstraint: NSLayoutConstraint?
    internal var navigationViewConstraint: NSLayoutConstraint?
    private lazy var mainScrollViewTop: NSLayoutYAxisAnchor = topLayoutGuide.bottomAnchor
    private var mainScrollViewConstraints: [NSLayoutConstraint] = []

    internal var headerViewHeight: CGFloat = 0.0
    private let headerContentView = UIView()
    private let menuContentView = UIView()
    private var menuViewHeight: CGFloat = 0.0
    internal var menuViewPinHeight: CGFloat = 0.0
    internal var sillValue: CGFloat = 0.0
    private var childControllerCount = 0
    private var countArray = [Int]()
    private var containViews = [HeadPageContainView]()
    internal var currentChildScrollView: UIScrollView?
    private var childScrollViewObservation: NSKeyValueObservation?
    internal var isAdsorption: Bool = false

    private let memoryCache = NSCache<NSString, UIViewController>()
    public weak var dataSource: HeadPageControllerDataSource?
    public weak var delegate: HeadPageControllerDelegate?

    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        obtainDataSource()
        setupOriginContent()
        setupDataSource()
        view.layoutIfNeeded()
        if originIndex > 0 {
            setSelect(index: originIndex, animation: false)
        } else {
            showChildViewContoller(at: originIndex)
            didDisplayViewController(at: originIndex)
        }
    }

    deinit {
        childScrollViewObservation?.invalidate()
    }

    internal func obtainDataSource() {
        if let value = dataSource?.sourceViewFor(self) {
            sourceView = value
        }

        if let value = dataSource?.originIndexFor(self) {
            originIndex = value
        }

        if let value = dataSource?.headerViewHeightFor(self) {
            headerViewHeight = value
        }

        if let value = dataSource?.menuViewHeightFor(self) {
            menuViewHeight = value
        }

        if let value = dataSource?.menuViewPinHeightFor(self) {
            menuViewPinHeight = value
        }

        if let value = dataSource?.numberOfViewControllers(in: self) {
            childControllerCount = value
        }

        sillValue = headerViewHeight - menuViewPinHeight
        countArray = Array(stride(from: 0, to: childControllerCount, by: 1))
    }

    private func setupOriginContent() {
        guard let sourceView = self.sourceView == nil ? view : self.sourceView else { return }
        mainScrollView.headerViewHeight = headerViewHeight
        mainScrollView.menuViewHeight = menuViewHeight
        if #available(iOS 13.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        if sourceView != view {
            mainScrollViewTop = sourceView.topAnchor
        }

        sourceView.addSubview(mainScrollView)
        let contentInset = dataSource?.contentInsetFor(self) ?? .zero
        let constraints = [
            mainScrollView.topAnchor.constraint(equalTo: mainScrollViewTop, constant: contentInset.top),
            mainScrollView.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor, constant: contentInset.left),
            mainScrollView.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor, constant: -contentInset.bottom),
            mainScrollView.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: -contentInset.right)
        ]
        mainScrollViewConstraints = constraints
        NSLayoutConstraint.activate(constraints)


        mainScrollView.addSubview(headerContentView)
        headerContentView.translatesAutoresizingMaskIntoConstraints = false

        let headerContentViewHeight = headerContentView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerViewConstraint = headerContentViewHeight
        NSLayoutConstraint.activate([
            headerContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            headerContentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            headerContentViewHeight,
        ])

        mainScrollView.addSubview(menuContentView)
        menuContentView.translatesAutoresizingMaskIntoConstraints = false

        let menuContentViewHeight = menuContentView.heightAnchor.constraint(equalToConstant: menuViewHeight)
        menuViewConstraint = menuContentViewHeight
        NSLayoutConstraint.activate([
            menuContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            menuContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            menuContentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            menuContentView.topAnchor.constraint(equalTo: headerContentView.bottomAnchor),
            menuContentViewHeight
        ])


        mainScrollView.addSubview(contentScrollView)

        let contentScrollViewHeight = contentScrollView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor, constant: -menuViewHeight - menuViewPinHeight)
        contentScrollViewConstraint = contentScrollViewHeight
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentScrollView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            contentScrollView.topAnchor.constraint(equalTo: menuContentView.bottomAnchor),
            contentScrollViewHeight
            ])


        contentScrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentStackView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor)
        ])

        mainScrollView.bringSubviewToFront(menuContentView)
        mainScrollView.bringSubviewToFront(headerContentView)
    }

    internal func updateOriginContent() {
        guard let dataSource = dataSource else { return }
        mainScrollView.headerViewHeight = headerViewHeight
        mainScrollView.menuViewHeight = menuViewHeight

        if mainScrollViewConstraints.count == 4 {
            let contentInset = dataSource.contentInsetFor(self)
            mainScrollViewConstraints.first?.constant = contentInset.top
            mainScrollViewConstraints[1].constant = contentInset.left
            mainScrollViewConstraints[2].constant = -contentInset.bottom
            mainScrollViewConstraints.last?.constant = -contentInset.right
        }
        headerViewConstraint?.constant = headerViewHeight
        menuViewConstraint?.constant = menuViewHeight
        contentScrollViewConstraint?.constant = -menuViewHeight - menuViewPinHeight
    }

    internal func clear() {
        childScrollViewObservation?.invalidate()

        originIndex = 0
        currentIndex = 0

        mainScrollView.am_isCanScroll = true
        currentChildScrollView?.am_isCanScroll = false

        childControllerCount = 0

        currentViewController = nil
        currentChildScrollView?.am_originOffset = nil
        currentChildScrollView = nil

        menuContentView.subviews.forEach({$0.removeFromSuperview()})
        headerContentView.subviews.forEach({$0.removeFromSuperview()})
        contentScrollView.contentOffset = .zero

        contentStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        clearMemoryCache()

        containViews.forEach({$0.viewController?.clearFromParent()})
        containViews.removeAll()

        countArray.removeAll()
    }

    internal func clearMemoryCache() {
        countArray.forEach { (index) in
            let viewController = memoryCache[index] as? (UIViewController & HeadPageChildViewController)
            let scrollView = viewController?.headPageChildScrollView()
            scrollView?.am_originOffset = nil
        }
        memoryCache.removeAllObjects()
    }

    internal func setupDataSource() {
        memoryCache.countLimit = childControllerCount

        if let navigationView: UIView = dataSource?.navigationViewFor(self),
           let navigationViewHeight: CGFloat = dataSource?.navigationViewHeightFor(self),
           let sourceView = sourceView {
            let headerContentViewHeight = navigationView.heightAnchor.constraint(equalToConstant: navigationViewHeight)
            navigationViewConstraint = headerContentViewHeight
            mainScrollViewTop = navigationView.bottomAnchor
            sourceView.addSubview(navigationView)
            navigationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                navigationView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                navigationView.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor),
                navigationView.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor),
                headerContentViewHeight
            ])
        }

        let headerView = dataSource?.headerViewFor(self) ?? .init()
        headerContentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: headerContentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerContentView.bottomAnchor),
            headerView.topAnchor.constraint(equalTo: headerContentView.topAnchor)
            ])

        let menuView = dataSource?.menuViewFor(self) ?? .init()
        menuContentView.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: menuContentView.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuContentView.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: menuContentView.bottomAnchor),
            menuView.topAnchor.constraint(equalTo: menuContentView.topAnchor)
            ])


        countArray.forEach { (_) in
            let containView = HeadPageContainView()
            contentStackView.addArrangedSubview(containView)
            NSLayoutConstraint.activate([
                containView.heightAnchor.constraint(equalTo: contentScrollView.heightAnchor),
                containView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
                ])
            containViews.append(containView)
        }

    }

    internal func showChildViewContoller(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
            return
        }

        let containView = containViews[index]
        guard containView.isEmpty else {
            return
        }

        let cachedViewContoller = memoryCache[index] as? (UIViewController & HeadPageChildViewController)
        let viewController = cachedViewContoller != nil ? cachedViewContoller : dataSource?.pageController(self, viewControllerAt: index)

        guard let targetViewController = viewController else {
            return
        }
        delegate?.pageController(self, willDisplay: targetViewController, forItemAt: index)

        addChild(targetViewController)
        targetViewController.beginAppearanceTransition(true, animated: false)
        containView.addSubview(targetViewController.view)
        targetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetViewController.view.leadingAnchor.constraint(equalTo: containView.leadingAnchor),
            targetViewController.view.trailingAnchor.constraint(equalTo: containView.trailingAnchor),
            targetViewController.view.bottomAnchor.constraint(equalTo: containView.bottomAnchor),
            targetViewController.view.topAnchor.constraint(equalTo: containView.topAnchor),
            ])
        targetViewController.endAppearanceTransition()
        targetViewController.didMove(toParent: self)
        targetViewController.view.layoutSubviews()
        containView.viewController = targetViewController

        let scrollView = targetViewController.headPageChildScrollView()
        scrollView.am_originOffset = scrollView.contentOffset

        if mainScrollView.contentOffset.y < sillValue {
            scrollView.contentOffset = scrollView.am_originOffset ?? .zero
            scrollView.am_isCanScroll = false
            mainScrollView.am_isCanScroll = true
        }
    }


    private func removeChildViewController(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
                return
        }

        let containView = containViews[index]
        guard containView.isEmpty == false
            , let viewController = containView.viewController else {
            return
        }
        viewController.clearFromParent()
        if memoryCache[index] == nil {
            delegate?.pageController(self, willCache: viewController, forItemAt: index)
            memoryCache[index] = viewController
        }
    }

    internal func layoutChildViewControlls() {
        countArray.forEach { (index) in
            let containView = containViews[index]
            let isDisplayingInScreen = containView.displayingIn(view: view, containView: contentScrollView)
            isDisplayingInScreen ? showChildViewContoller(at: index) : removeChildViewController(at: index)
        }
    }

    internal func contentScrollViewDidEndScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.width
        guard scrollViewWidth > 0 else {
            return
        }

        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollViewWidth)
        didDisplayViewController(at: index)
        delegate?.pageController(self, contentScrollViewDidEndScroll: contentScrollView)
    }

    internal func didDisplayViewController(at index: Int) {
        guard childControllerCount > 0
            , index >= 0
            , index < childControllerCount
            , containViews.isEmpty == false else {
                return
        }
        let containView = containViews[index]
        currentViewController = containView.viewController
        currentChildScrollView = currentViewController?.headPageChildScrollView()
        currentIndex = index

        childScrollViewObservation?.invalidate()
        let keyValueObservation = currentChildScrollView?.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (scrollView, change) in
            guard let self = self, change.newValue != change.oldValue else {
                return
            }
            self.childScrollViewDidScroll(scrollView)
        })
        childScrollViewObservation = keyValueObservation

        if let viewController = containView.viewController {
            delegate?.pageController(self, didDisplay: viewController, forItemAt: index)
        }
    }

    /// All ScrollView contentOffset to .zero
    public func allScrollViewScrollToTop() {
        containViews.forEach {
            let vc = $0.viewController
            let scrollView = vc?.headPageChildScrollView()
            scrollView?.contentOffset = .zero
        }

        mainScrollView.contentOffset = .zero
    }

    public func updateNavigationHeight(_ height: CGFloat, duration: TimeInterval = 0.3) {
        self.navigationViewConstraint?.constant = height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}


