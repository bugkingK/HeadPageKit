//
//  BottomLineViewStyle.swift
//
//
//  Created by Kimun Kwon on 2020/10/26.
//

import Foundation
import UIKit

extension UIFont {
    var weightValue: Float {
        guard let value = traits[.weight] as? NSNumber else {
            return 0
        }
        return value.floatValue
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    }
}
