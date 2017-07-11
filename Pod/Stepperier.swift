//
//  Stepperier.swift
//  Stepperier
//
//  Created by David Elsonbaty on 6/19/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let defaultBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    static let defaultTintColor: UIColor = UIColor(red:109.0/255.0, green:114.0/255.0, blue:254.0/255.0, alpha:255.0/255.0)
    static let symbolSizeToStepperierHeightRatio: CGFloat = 0.25
    static let defaultFont: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightLight)
}

public protocol StepperierAnimationHandler {
    func animate(animations: @escaping ((Void) -> Void), completion: @escaping ((Void) -> Void))
}

internal struct PanGestureInteraction {
    let startPosition: CGPoint
}

open class Stepperier: UIControl {
    
    public var value: Int = 0 {
        didSet { didUpdateValue(value) }
    }
    
    public var minimumValue: Int = 0 {
        didSet { didUpdateValueBounds() }
    }
    
    public var maximumValue: Int = Int.max {
        didSet { didUpdateValueBounds() }
    }
    
    public var valueBackgroundColor: UIColor = .white {
        didSet { didUpdateValueBackgroundColor(valueBackgroundColor) }
    }
    
    public var operationSymbolsColor: UIColor = .white {
        didSet { didUpdateOperationSymbolsColor(operationSymbolsColor) }
    }
    
    public var font: UIFont = Constants.defaultFont {
        didSet { monoSpacedFont = font.monospacedDigitFont }
    }
    
    internal var monoSpacedFont: UIFont = Constants.defaultFont.monospacedDigitFont {
        didSet { didUpdateFont(font) }
    }
    
    public var symbolsLineWidth: CGFloat = 1.0 {
        didSet { didUpdateLineWidth(symbolsLineWidth) }
    }
    
    override open var tintColor: UIColor? {
        didSet { valueLabel.textColor = tintColor }
    }
    
    public var valueLabelMargin: CGFloat = 8.0 {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public var isOperationSymbolsManualClicksEnabled: Bool = true
    public var shouldDisableScrollingPastBoundaries: Bool = true
    public var shouldHideSymbolsUponReachingBounds: Bool = true {
        didSet { didUpdateHidingSymbolsPreference(shouldHideSymbolsUponReachingBounds) }
    }
    
    public var animationHandler: StepperierAnimationHandler = StepperiedDefaultAnimationHandler()
    
    internal var panGestureInteractionInformation: PanGestureInteraction?
    internal var counterContainerCenterXLayoutConstraint: NSLayoutConstraint?
    internal var proportionalCornerRadius: ProportionalCornerRadius = .circular
    internal lazy var valueLabel: UILabel = UILabel()
    internal lazy var additionSymbolControl: CenteredLineSymbolControl = CenteredLineSymbolControl(lineDirection: .allTheAbove)
    internal lazy var subtractionSymbolControl: CenteredLineSymbolControl = CenteredLineSymbolControl(lineDirection: .horizontal)
    internal lazy var countContainerView: RoundableView = RoundableView(proportionalCornerRadius: .circular)
    internal lazy var leftOrganizationStackView: UIStackView = UIStackView()
    internal lazy var middleOrganizationStackView: UIStackView = UIStackView()
    internal lazy var rightOrganizationStackView: UIStackView = UIStackView()
    internal lazy var organizationStackView: UIStackView = UIStackView(arrangedSubviews: [self.leftOrganizationStackView, self.middleOrganizationStackView, self.rightOrganizationStackView])
    
    open override var intrinsicContentSize: CGSize {
        let textSize: CGSize = value.description.size(forFont: monoSpacedFont, maxNumberOfLines: 1)
        let height: CGFloat = valueLabelMargin.multiplied(by: 2).advanced(by: textSize.height)
        let symbolWidth: CGFloat = Constants.symbolSizeToStepperierHeightRatio * height
        let width: CGFloat = height.multiplied(by: 2) + (valueLabelMargin.multiplied(by: 2) + symbolWidth)
        return CGSize(width: width, height: height)
    }
    
    public init() {
        super.init(frame: .zero)
        commonInitalization()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitalization()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = proportionalCornerRadius.cornerRadius(forSize: self.bounds.size)
    }
    
    internal func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidRecieveInteraction(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    internal func commonInitalization() {
        
        layer.masksToBounds = true
        tintColor = Constants.defaultTintColor
        backgroundColor = Constants.defaultBackgroundColor
        
        organizationStackView.axis = .horizontal
        organizationStackView.distribution = .fillProportionally
        addSubview(organizationStackView)
        
        subtractionSymbolControl.isOpaque = false
        subtractionSymbolControl.lineWidth = symbolsLineWidth
        subtractionSymbolControl.color = valueBackgroundColor
        subtractionSymbolControl.addTarget(self, action: #selector(didTapSubtractionSymbol), for: .touchUpInside)
        addSubview(subtractionSymbolControl)
        
        additionSymbolControl.isOpaque = false
        additionSymbolControl.lineWidth = symbolsLineWidth
        additionSymbolControl.color = valueBackgroundColor
        additionSymbolControl.addTarget(self, action: #selector(didTapAdditionSymbol), for: .touchUpInside)
        addSubview(additionSymbolControl)
        
        countContainerView.backgroundColor = valueBackgroundColor
        addSubview(countContainerView)

        valueLabel.font = monoSpacedFont
        valueLabel.textColor = tintColor
        valueLabel.text = value.description
        valueLabel.textAlignment = .center
        countContainerView.addSubview(valueLabel)
        
        setupLayoutConstraints()
        setupPanGestureRecognizer()
        updateSymbolsAppearanceState()
    }
    
    internal func setupLayoutConstraints() {
        
        countContainerView.translatesAutoresizingMaskIntoConstraints = false
        countContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let widthConstraint = countContainerView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        widthConstraint.priority = 750
        widthConstraint.isActive = true
        
        countContainerView.rightAnchor.constraint(greaterThanOrEqualTo: valueLabel.rightAnchor, constant: valueLabelMargin).isActive = true
        countContainerView.leftAnchor.constraint(greaterThanOrEqualTo: valueLabel.leftAnchor, constant: -valueLabelMargin).isActive = true
        
        countContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
        counterContainerCenterXLayoutConstraint = countContainerView.centerXAnchor.constraint(equalTo: centerXAnchor)
        counterContainerCenterXLayoutConstraint?.isActive = true
        
        organizationStackView.translatesAutoresizingMaskIntoConstraints = false
        organizationStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        organizationStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        organizationStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        organizationStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        
        middleOrganizationStackView.translatesAutoresizingMaskIntoConstraints = false
        middleOrganizationStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        middleOrganizationStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        middleOrganizationStackView.widthAnchor.constraint(equalTo: countContainerView.widthAnchor, multiplier: 1.0).isActive = true
        middleOrganizationStackView.heightAnchor.constraint(equalTo: countContainerView.heightAnchor, multiplier: 1.0).isActive = true
        
        subtractionSymbolControl.translatesAutoresizingMaskIntoConstraints = false
        subtractionSymbolControl.centerXAnchor.constraint(equalTo: leftOrganizationStackView.centerXAnchor).isActive = true
        subtractionSymbolControl.centerYAnchor.constraint(equalTo: leftOrganizationStackView.centerYAnchor).isActive = true
        subtractionSymbolControl.widthAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.symbolSizeToStepperierHeightRatio).isActive = true
        subtractionSymbolControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.symbolSizeToStepperierHeightRatio).isActive = true
        
        additionSymbolControl.translatesAutoresizingMaskIntoConstraints = false
        additionSymbolControl.centerXAnchor.constraint(equalTo: rightOrganizationStackView.centerXAnchor).isActive = true
        additionSymbolControl.centerYAnchor.constraint(equalTo: rightOrganizationStackView.centerYAnchor).isActive = true
        additionSymbolControl.widthAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.symbolSizeToStepperierHeightRatio).isActive = true
        additionSymbolControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.symbolSizeToStepperierHeightRatio).isActive = true
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: countContainerView.centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: countContainerView.centerYAnchor).isActive = true
        valueLabel.setContentCompressionResistancePriority(.infinity, for: .horizontal)
    }
    
    internal func updateSymbolsAppearanceState() {
        let alpha: ((Bool) -> CGFloat) = { $0 ? 1.0 : 0.2 }
        additionSymbolControl.alpha = alpha(!(shouldHideSymbolsUponReachingBounds && value >= maximumValue))
        subtractionSymbolControl.alpha = alpha(!(shouldHideSymbolsUponReachingBounds && value <= minimumValue))
    }
    
    internal func panGestureDidRecieveInteraction(_ panGesture: UIPanGestureRecognizer) {
        guard let counterContainerCenterXLayoutConstraint = counterContainerCenterXLayoutConstraint else { return }
        
        let gestureLocation = panGesture.location(in: self)
        if panGesture.state == .began {
            panGestureInteractionInformation = PanGestureInteraction(startPosition: gestureLocation)
        } else if panGesture.state == .changed {
            guard let panGestureInteractionInformation = panGestureInteractionInformation else { return }
            
            let offsetFromStart = gestureLocation.x.subtracting(panGestureInteractionInformation.startPosition.x)
            let halfCounterContainerViewWidth = countContainerView.bounds.width.divided(by: 2.0)
            let centerX = bounds.width.divided(by: 2.0)
            let maxCenterOffset = additionSymbolControl.frame.minX.adding(halfCounterContainerViewWidth).subtracting(centerX)
            let maxCenterOffsetForAddition = (value < maximumValue || !shouldDisableScrollingPastBoundaries) ? maxCenterOffset : 0
            let minCenterOffsetForSubtraction = (value > minimumValue || !shouldDisableScrollingPastBoundaries) ? -maxCenterOffset : 0
            counterContainerCenterXLayoutConstraint.constant = min(max(offsetFromStart, minCenterOffsetForSubtraction), maxCenterOffsetForAddition)
        } else if panGesture.state == .ended {
            
            let centerX = bounds.width.divided(by: 2.0)
            let halfCounterContainerViewWidth = countContainerView.bounds.width.divided(by: 2.0)
            let threshhold = additionSymbolControl.frame.maxX.subtracting(halfCounterContainerViewWidth).subtracting(centerX)
            let movement = counterContainerCenterXLayoutConstraint.constant
            if value > minimumValue && movement <= -threshhold {
                updateValueWithEvents(value - 1)
            } else if value < maximumValue && movement >= threshhold {
                updateValueWithEvents(value + 1)
            }
            
            // Reset
            counterContainerCenterXLayoutConstraint.constant = 0
            animationHandler.animate(animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.layoutIfNeeded()
                }, completion: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    strongSelf.panGestureInteractionInformation = nil
            })
        }
    }

    internal func updateValueWithEvents(_ value: Int) {
        self.value = value
        sendActions(for: .valueChanged)
    }
}

internal struct StepperiedDefaultAnimationHandler: StepperierAnimationHandler {
    
    func animate(animations: @escaping ((Void) -> Void), completion: @escaping ((Void) -> Void)) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 2, options: .curveEaseInOut, animations: animations, completion: { _ in
            completion()
        })
    }
}

// MARK: Setters

extension Stepperier {
    
    internal func didTapAdditionSymbol() {
        guard isOperationSymbolsManualClicksEnabled && value < maximumValue else { return }
        updateValueWithEvents(value + 1)
    }
    
    internal func didTapSubtractionSymbol() {
        guard isOperationSymbolsManualClicksEnabled && value > minimumValue else { return }
        updateValueWithEvents(value - 1)
    }
    
    internal func didUpdateValue(_ value: Int) {
        valueLabel.text = value.description
        updateSymbolsAppearanceState()
    }
    
    internal func didUpdateValueBounds() {
        updateSymbolsAppearanceState()
    }

    internal func didUpdateFont(_ font: UIFont) {
        valueLabel.font = font
        invalidateIntrinsicContentSize()
    }
    
    internal func didUpdateValueBackgroundColor(_ color: UIColor) {
        countContainerView.backgroundColor = color
    }
    
    internal func didUpdateOperationSymbolsColor(_ color: UIColor) {
        additionSymbolControl.color = color
        subtractionSymbolControl.color = color
    }
    
    internal func didUpdateLineWidth(_ lineWidth: CGFloat) {
        additionSymbolControl.lineWidth = lineWidth
        subtractionSymbolControl.lineWidth = lineWidth
    }
    
    internal func didUpdateHidingSymbolsPreference(_ shouldHide: Bool) {
        updateSymbolsAppearanceState()
    }
}
