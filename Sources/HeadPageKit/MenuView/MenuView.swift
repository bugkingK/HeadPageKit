//
//  BottomLineViewStyle.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

public enum MenuStyle {
    case normalTextFont(UIFont)
    case selectedTextFont(UIFont)
    case itemSpace(CGFloat)
    case normalTextColor(UIColor)
    case selectedTextColor(UIColor)
    case contentInset(UIEdgeInsets)
    case sliderStyle(SliderViewStyle)
    case bottomLineStyle(BottomLineViewStyle)
    case switchStyle(MenuSwitchStyle)
}

public enum MenuSwitchStyle {
    case line
    case telescopic
}

public protocol MenuViewProtocol: AnyObject {
    var delegate: MenuViewDelegate? { get set }
    var titles: [String] { get set }
    /// Any offset changes in pageController's contentScrollView
    func contentScrollViewDidScroll(_ scrollView: UIScrollView)
    /// Method call when pageController did display
    func didDisplay(_ animation: Bool)
}

public protocol MenuViewDelegate: AnyObject {
    func menuView(_ menuView: MenuView, didSelectedItemAt index: Int)
}

public class MenuView: UIView, MenuViewProtocol {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = itemSpace
        return stackView
    }()
    
    private var scrollViewConstraints: [NSLayoutConstraint] = []
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    private var sliderWidth: NSLayoutConstraint?
    private var sliderCenterX: NSLayoutConstraint?
    private lazy var sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = selectedTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    private var menuItemViews = [MenuItemView]()
    public weak var delegate: MenuViewDelegate?
    
    private var normalTextFont = UIFont.systemFont(ofSize: 15.0)
    private var selectedTextFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    public var itemSpace:CGFloat = 30.0 {
        didSet {
            stackView.spacing = itemSpace
            layoutIfNeeded()
            layoutSlider()
            scrollView.scrollToSuitablePosition(currentLabel, false)
        }
    }
    private var normalTextColor = UIColor.darkGray
    private var selectedTextColor = UIColor.red
    public var contentInset = UIEdgeInsets.zero {
        didSet {
            guard let _ = scrollView.superview else {
                return
            }
            
            if scrollViewConstraints.count == 4 {
                scrollViewConstraints.first?.constant = contentInset.top
                scrollViewConstraints[1].constant = contentInset.left
                scrollViewConstraints[2].constant = -contentInset.bottom
                scrollViewConstraints.last?.constant = -contentInset.right
            }
            
        }
    }
    public private(set) lazy var sliderViewStyle = SliderViewStyle(view: sliderView)
    public private(set) lazy var bottomLineViewStyle = BottomLineViewStyle(view: bottomLineView)
    private var switchStyle = MenuSwitchStyle.line
    
    public init(parts: MenuStyle...) {
        super.init(frame: .zero)
        for part in parts {
            switch part {
            case .normalTextFont(let font):
                normalTextFont = font
            case .selectedTextFont(let font):
                selectedTextFont = font
            case .itemSpace(let space):
                itemSpace = space
            case .normalTextColor(let color):
                normalTextColor = color
            case .selectedTextColor(let color):
                selectedTextColor = color
            case .contentInset(let inset):
                contentInset = inset
            case .sliderStyle(let style):
                sliderViewStyle = style
                sliderViewStyle.targetView = sliderView
            case .switchStyle(let style):
                switchStyle = style
            case .bottomLineStyle(let style):
                bottomLineViewStyle = style
                bottomLineViewStyle.targetView = bottomLineView
            }
        }
        initialize()
    }
    
    
    private var scrollRate: CGFloat = 0.0 {
        didSet {
            currentLabel?.rate = 1.0 - scrollRate
            nextLabel?.rate = scrollRate
        }
    }
    
    public var titles = [String]() {
        didSet {
            stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            menuItemViews.removeAll()
            guard titles.isEmpty == false else {
                return
            }
            titles.forEach { (item) in
                let itemView = MenuItemView(item,
                                            normalTextFont,
                                            selectedTextFont,
                                            normalTextColor,
                                            selectedTextColor)
                itemView.isUserInteractionEnabled = true
                itemView.translatesAutoresizingMaskIntoConstraints = false
                let tap = UITapGestureRecognizer(target: self, action: #selector(titleTapAction(_:)))
                itemView.addGestureRecognizer(tap)
                stackView.addArrangedSubview(itemView)
                itemView.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
                menuItemViews.append(itemView)
            }

            currentIndex = 0
            
            stackView.layoutIfNeeded()
            let labelWidth = stackView.arrangedSubviews.first?.bounds.width ?? 0.0
            var progressWidth: CGFloat = 0
            switch switchStyle {
            case .telescopic:
                progressWidth = sliderViewStyle.originWidth
            default:
                switch sliderViewStyle.shape {
                case .line:
                    progressWidth = labelWidth + sliderViewStyle.extraWidth
                case .round:
                    progressWidth = sliderViewStyle.height
                case .triangle:
                    progressWidth = sliderViewStyle.height + sliderViewStyle.extraWidth
                }
            }
            
            let offset = stackView.arrangedSubviews.first?.frame.midX ?? 0.0
            sliderWidth?.constant = progressWidth
            sliderCenterX?.constant = offset
            
            didDisplay(false)
        }
    }
    
    private var itemMidSpace: CGFloat {
        guard let currentLabel = currentLabel
            , let nextLabel = nextLabel else {
                return 0.0
        }
        
        let value = nextLabel.frame.minX - currentLabel.frame.midX + nextLabel.bounds.width * 0.5
        return value
    }
    
    private var widthDifference: CGFloat {
        guard let currentLabel = currentLabel
            , let nextLabel = nextLabel else {
                return 0.0
        }
        
        let value = nextLabel.bounds.width - currentLabel.bounds.width
        return value
    }
    
    private var centerXDifference: CGFloat {
        guard let currentLabel = currentLabel
            , let nextLabel = nextLabel else {
                return 0.0
        }
        let value = nextLabel.frame.midX - currentLabel.frame.midX
        return value
    }
    
    private var nextIndex = 0 {
        didSet {
            guard nextIndex < titles.count
                , nextIndex >= 0 else {
                return
            }
            nextLabel = menuItemViews[nextIndex]
        }
    }
    
    private var currentIndex = 0 {
        didSet {
            guard currentIndex < titles.count
                , currentIndex >= 0 else {
                return
            }
            if currentIndex == titles.count - 1 {
                let next = currentIndex - 1
                nextIndex = next > 0 ? next : 0
            } else {
                nextIndex = currentIndex + 1
            }
            currentLabel = menuItemViews[currentIndex]
        }
    }
    private var currentLabel: MenuItemView?
    private var nextLabel: MenuItemView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(scrollView)
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: contentInset.top),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInset.left),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInset.bottom),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInset.right)
        ]
        scrollViewConstraints = constraints
        NSLayoutConstraint.activate(constraints)
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        scrollView.addSubview(sliderView)
        scrollView.sendSubviewToBack(sliderView)
        
        let sliderWidth: NSLayoutConstraint = sliderView.widthAnchor.constraint(equalToConstant: 0)
        let sliderCenterX: NSLayoutConstraint = sliderView.centerXAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0)
        var sliderPositionLayout: NSLayoutConstraint!
        switch sliderViewStyle.position {
        case .bottom:
            sliderPositionLayout = sliderView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        case .center:
            sliderPositionLayout = sliderView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        case .top:
            sliderPositionLayout = sliderView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        }
        NSLayoutConstraint.activate([
            sliderWidth, sliderPositionLayout, sliderCenterX,
        ])
        self.sliderWidth = sliderWidth
        self.sliderCenterX = sliderCenterX
        
        addSubview(bottomLineView)
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    private func clear() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        menuItemViews.removeAll()
    }
    
    @objc private func titleTapAction(_ sender: UIGestureRecognizer) {
        guard let targetView = sender.view
            , let index = stackView.arrangedSubviews.firstIndex(of: targetView) else {
            return
        }
        delegate?.menuView(self, didSelectedItemAt: index)
    }
    
    public func contentScrollViewDidScroll(_ scrollView: UIScrollView) {
        guard currentIndex >= 0, currentIndex < titles.count else {
            return
        }
        let scrollViewWidth = scrollView.bounds.width
        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollViewWidth)
        guard index >= 0, index < titles.count else {
            return
        }
        
        currentIndex = index
        let value: CGFloat = offsetX > CGFloat(titles.count - 1) * scrollView.bounds.width ? -1 : 1
        scrollRate = value * (offsetX - CGFloat(currentIndex) * scrollViewWidth) / scrollViewWidth
        layoutSlider(scrollRate)
    }
    
    public func didDisplay(_ animation: Bool) {
        guard currentIndex >= 0
            , currentIndex < titles.count else {
            return
        }
        menuItemViews.forEach({$0.isSelected = false})
        menuItemViews[currentIndex].isSelected = true
        
        currentLabel = menuItemViews[currentIndex]
        nextLabel = menuItemViews[nextIndex]
        guard let currentLabel = currentLabel else {
            return
        }
        scrollView.scrollToSuitablePosition(currentLabel, animation)
    }
    
    func layoutSlider(_ scrollRate: CGFloat = 0.0) {

        let currentWidth = stackView.arrangedSubviews[currentIndex].bounds.width
        let leadingMargin = stackView.arrangedSubviews[currentIndex].frame.midX

        switch switchStyle {
        case .line:
            switch sliderViewStyle.shape {
            case .line:
                sliderWidth?.constant = widthDifference * scrollRate + currentWidth + sliderViewStyle.extraWidth
            case .triangle:
                sliderWidth?.constant = sliderViewStyle.height + sliderViewStyle.extraWidth
            case .round:
                sliderWidth?.constant = sliderViewStyle.height
            }
            sliderCenterX?.constant = leadingMargin + itemMidSpace * scrollRate
        case .telescopic:
            let rate = (scrollRate <= 0.5 ? scrollRate : (1.0 - scrollRate)) * sliderViewStyle.elasticValue
            sliderWidth?.constant = max(centerXDifference * rate + sliderViewStyle.originWidth, 0)
            sliderCenterX?.constant = leadingMargin + itemMidSpace * scrollRate
        }
    }
}

