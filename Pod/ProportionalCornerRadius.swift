//
//  ProportionalCornerRadius.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import CoreGraphics

internal enum ProportionalCornerRadius {
    case circular
    case toWidth(CGFloat)
    case toHeight(CGFloat)
    internal func cornerRadius(forSize size: CGSize) -> CGFloat {
        switch self {
        case .toHeight(let factor):
            return size.height * factor
        case .toWidth(let factor):
            return size.width * factor
        case .circular:
            return size.height * 0.5
        }
    }
}
