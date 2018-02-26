//
//  RoundableView.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

internal class RoundableView: UIView {
    
    internal var proportionalCornerRadius: ProportionalCornerRadius?
    
    // MARK: Initialization
    public convenience init(proportionalCornerRadius: ProportionalCornerRadius) {
        self.init(frame: CGRect.zero)
        self.proportionalCornerRadius = proportionalCornerRadius
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitalization()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitalization()
    }
    
    internal func commonInitalization() {
        
    }
    
    // MARK: Layout
    internal override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    internal func roundCorners() {
        if let proportionalCornerRadius = proportionalCornerRadius {
            layer.masksToBounds = true
            layer.cornerRadius = proportionalCornerRadius.cornerRadius(forSize: self.bounds.size)
        }
    }
}
