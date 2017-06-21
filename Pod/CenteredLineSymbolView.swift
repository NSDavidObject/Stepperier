//
//  CenteredLineSymbolView.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

internal class CenteredLineSymbolView: UIView {
    
    enum LineDirection {
        case vertical
        case horizontal
        case allTheAbove
        
        var includesHorizontal: Bool {
            switch self {
            case .horizontal: return true
            case .allTheAbove: return true
            default: return false
            }
        }
        
        var includesVertical: Bool {
            switch self {
            case .vertical: return true
            case .allTheAbove: return true
            default: return false
            }
        }
    }
    
    var lineWidth: CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }
    
    var color: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }
    
    let lineDirection: LineDirection
    init(lineDirection: LineDirection) {
        self.lineDirection = lineDirection
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        
        if lineDirection.includesVertical {
            context.move(to: CGPoint(x: bounds.width.divided(by: 2.0), y: 0.0))
            context.addLine(to: CGPoint(x: bounds.width.divided(by: 2.0), y: bounds.height))
        }
        
        if lineDirection.includesHorizontal {
            context.move(to: CGPoint(x: 0.0, y: bounds.height.divided(by: 2.0)))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height.divided(by: 2.0)))
        }
        
        context.strokePath()
    }
}
