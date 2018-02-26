//
//  UIFont+Additions.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

extension UIFont {
    
    var monospacedDigitFont: UIFont {
        return UIFont(descriptor: fontDescriptor.monospacedDigitFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [
            [
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]
        ]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}
