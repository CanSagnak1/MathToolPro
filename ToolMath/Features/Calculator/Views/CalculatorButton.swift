//
//  CalculatorButton.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class CalculatorButton: UIButton {

    enum ButtonType {
        case number
        case operation
        case equals
        case clear
        case function
        case parenthesis
    }

    private let calcButtonType: ButtonType
    private let gradientLayer = CAGradientLayer()
    private let shadowLayer = CALayer()

    init(title: String, type: ButtonType) {
        self.calcButtonType = type
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setupAppearance()
        setupGradient()
        setupShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        shadowLayer.frame = bounds
        gradientLayer.cornerRadius = 16
        shadowLayer.cornerRadius = 16
    }

    private func setupAppearance() {
        layer.cornerRadius = 16
        titleLabel?.font =
            calcButtonType == .function
            ? Theme.Fonts.display(size: 16, weight: .semibold)
            : Theme.Fonts.display(size: 24, weight: .semibold)

        switch calcButtonType {
        case .number:
            setTitleColor(.white, for: .normal)
        case .operation:
            setTitleColor(.white, for: .normal)
        case .equals:
            setTitleColor(.white, for: .normal)
        case .clear:
            setTitleColor(.white, for: .normal)
        case .function:
            setTitleColor(Theme.Colors.primary, for: .normal)
        case .parenthesis:
            setTitleColor(.white, for: .normal)
        }
    }

    private func setupGradient() {
        var colors: [CGColor] = []

        switch calcButtonType {
        case .number:
            colors = [
                UIColor(red: 0.20, green: 0.22, blue: 0.31, alpha: 1).cgColor,
                UIColor(red: 0.16, green: 0.18, blue: 0.27, alpha: 1).cgColor,
            ]
        case .operation:
            colors = [
                UIColor(red: 0.00, green: 0.90, blue: 1.00, alpha: 1).cgColor,
                UIColor(red: 0.00, green: 0.76, blue: 0.94, alpha: 1).cgColor,
            ]
        case .equals:
            colors = [
                UIColor(red: 0.40, green: 0.49, blue: 0.92, alpha: 1).cgColor,
                UIColor(red: 0.46, green: 0.29, blue: 0.64, alpha: 1).cgColor,
            ]
        case .clear:
            colors = [
                UIColor(red: 1.00, green: 0.35, blue: 0.43, alpha: 1).cgColor,
                UIColor(red: 1.00, green: 0.24, blue: 0.31, alpha: 1).cgColor,
            ]
        case .function:
            colors = [
                UIColor(red: 0.27, green: 0.29, blue: 0.39, alpha: 1).cgColor,
                UIColor(red: 0.24, green: 0.25, blue: 0.35, alpha: 1).cgColor,
            ]
        case .parenthesis:
            colors = [
                UIColor(red: 0.20, green: 0.22, blue: 0.31, alpha: 1).cgColor,
                UIColor(red: 0.16, green: 0.18, blue: 0.27, alpha: 1).cgColor,
            ]
        }

        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    override var isHighlighted: Bool {
        didSet {
            animatePress(isHighlighted)
        }
    }

    private func animatePress(_ pressed: Bool) {
        let scale: CGFloat = pressed ? 0.95 : 1.0
        let glowOpacity: Float = pressed ? 0.6 : 0.3

        UIView.animate(
            withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]
        ) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        if calcButtonType == .operation || calcButtonType == .equals {
            let glowColor =
                calcButtonType == .operation
                ? Theme.Colors.primary.cgColor
                : UIColor(red: 0.46, green: 0.29, blue: 0.64, alpha: 1).cgColor

            UIView.animate(withDuration: 0.15) {
                self.layer.shadowColor = glowColor
                self.layer.shadowOpacity = pressed ? glowOpacity : 0.3
                self.layer.shadowRadius = pressed ? 16 : 8
            }
        }

        if pressed {
            HapticManager.shared.impact()
        }
    }

    func addPulsatingGlow() {
        guard calcButtonType == .equals else { return }

        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.3
        animation.toValue = 0.7
        animation.duration = 1.2
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "pulsate")
    }
}