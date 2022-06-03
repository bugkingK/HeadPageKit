//
//  Ex+HeadPageViewController.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import UIKit

extension HeadPageViewController {
    public func updateHeaderViewHeight(animated: Bool = false,
                                       duration: TimeInterval = 0.25,
                                       completion: ((Bool) -> Void)? = nil) {
        
        headerViewHeight = dataSource?.headerViewHeightFor(self) ?? 0
        sillValue = headerViewHeight - menuViewPinHeight
        
        mainScrollView.headerViewHeight = headerViewHeight
        headerViewConstraint?.constant = headerViewHeight
        
        var manualHandel = false
        if mainScrollView.contentOffset.y < sillValue {
            currentChildScrollView?.contentOffset = currentChildScrollView?.am_originOffset ?? .zero
            currentChildScrollView?.am_isCanScroll = false
            mainScrollView.am_isCanScroll = true
            manualHandel = true
        } else if mainScrollView.contentOffset.y == sillValue  {
            mainScrollView.am_isCanScroll = false
            manualHandel = true
        }

        isAdsorption = (headerViewHeight <= 0.0) ? true : !mainScrollView.am_isCanScroll
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.mainScrollView.layoutIfNeeded()
                if manualHandel {
                    self.delegate?.pageController(self, menuView: self.isAdsorption)
                }
            }) { (finish) in
                completion?(finish)
            }
        } else {
            delegate?.pageController(self, menuView: isAdsorption)
            completion?(true)
        }
    }
    
    public func setSelect(index: Int, animation: Bool) {
        let offset = CGPoint(x: contentScrollView.bounds.width * CGFloat(index),
                             y: contentScrollView.contentOffset.y)
        contentScrollView.setContentOffset(offset, animated: animation)
        if animation == false {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    public func reloadData() {
        mainScrollView.isUserInteractionEnabled = false
        clear()
        loadData(isUpdated: true)
        mainScrollView.isUserInteractionEnabled = true
    }
}


extension HeadPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {
            delegate?.pageController(self, mainScrollViewDidScroll: scrollView)
            let offsetY = scrollView.contentOffset.y
            if offsetY >= sillValue {
                scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                currentChildScrollView?.am_isCanScroll = true
                scrollView.am_isCanScroll = false
                isAdsorption = !scrollView.am_isCanScroll
                delegate?.pageController(self, menuView: isAdsorption)
            } else {
                isAdsorption = scrollView.am_isCanScroll == false
                if isAdsorption {
                    delegate?.pageController(self, menuView: isAdsorption)
                    scrollView.contentOffset = CGPoint(x: 0, y: sillValue)
                } else {
                    delegate?.pageController(self, menuView: isAdsorption)
                }
            }
        } else {
            menuView?.updateLayout(scrollView)
            delegate?.pageController(self, contentScrollViewDidScroll: scrollView)
            layoutChildViewControlls()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = false
        }
    }

    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentScrollView {
            mainScrollView.isScrollEnabled = true
            if decelerate == false {
                contentScrollViewDidEndScroll(contentScrollView)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            contentScrollViewDidEndScroll(contentScrollView)
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard scrollView == mainScrollView else {
            return false
        }
        currentChildScrollView?.setContentOffset(currentChildScrollView?.am_originOffset ?? .zero, animated: true)
        return true
    }
    
}

extension HeadPageViewController {
    internal func childScrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.am_isCanScroll == false {
            scrollView.contentOffset = scrollView.am_originOffset ?? .zero
        }
        let offsetY = scrollView.contentOffset.y
        if offsetY <= (scrollView.am_originOffset ?? .zero).y {
            scrollView.contentOffset = scrollView.am_originOffset ?? .zero
            scrollView.am_isCanScroll = false
            mainScrollView.am_isCanScroll = true
        }
    }
}
