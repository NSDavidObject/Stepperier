//
//  String+Additions.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

extension String {
    
    func size(forFont font: UIFont, boundedInWidth width: CGFloat = .infinity, maxNumberOfLines: Int = .max) -> CGSize {
        let maxHeight = CGFloat(maxNumberOfLines) * font.lineHeight
        let constraintRect = CGSize(width:  .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.size
    }
}
