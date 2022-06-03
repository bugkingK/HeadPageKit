//
//  BottomLineViewStyle.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//


import Foundation
import UIKit

extension UIColor {
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            return (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}
