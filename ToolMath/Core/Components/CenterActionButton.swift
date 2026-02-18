//
//  CenterActionButton.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

final class CenterActionButton: UIButton {

    // MARK: - Configuration

    private let buttonSize: CGFloat = 64
    private let iconPointSize: CGFloat = 28

    // MARK: - Layers

    private let gradientLayer: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.startPoint = CGPoint(x: 0.3, y: 0)
        gl.endPoint = CGPoint(x: 0.7, y: 1)
        return gl
    }()

    private let outerGlowLayer: CALayer = {
        let l = CALayer()
        return l
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }

    // MARK: - Setup

    private func setupButton() {
        // Tag for PremiumTabBar hitTest identification
        tag = 999

        translatesAutoresizingMaskIntoConstraints = false

        // Size constraints
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: buttonSize),
            heightAnchor.constraint(equalToConstant: buttonSize),
        ])

        // Gradient background
        let primaryColor = Theme.Colors.primary
        let darkerPrimary = primaryColor.withAlphaComponent(0.8)
        gradientLayer.colors = [
            primaryColor.cgColor,
            darkerPrimary.cgColor,
        ]
        gradientLayer.cornerRadius = buttonSize / 2
        layer.insertSublayer(gradientLayer, at: 0)

        // Corner radius
        layer.cornerRadius = buttonSize / 2
        clipsToBounds = false

        // Multi-layer shadow for depth
        layer.shadowColor = primaryColor.withAlphaComponent(0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 14

        // Label for "f(x)"
        let label = UILabel()
        label.text = "f(x)"
        label.font = Theme.Fonts.display(size: 20, weight: .bold)  // Adjusted size
        label.textColor = .white
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        // Interaction
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(
            self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    // MARK: - Pulse Animation (call after appearing)

    func startPulseAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.92
        pulse.toValue = 1.0
        pulse.damping = 8
        pulse.initialVelocity = 0.8
        pulse.duration = pulse.settlingDuration
        pulse.isRemovedOnCompletion = true
        layer.add(pulse, forKey: "initialPulse")

        // Glow pulse
        let glowPulse = CABasicAnimation(keyPath: "shadowRadius")
        glowPulse.fromValue = 14
        glowPulse.toValue = 22
        glowPulse.duration = 1.2
        glowPulse.autoreverses = true
        glowPulse.repeatCount = 2
        glowPulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glowPulse.isRemovedOnCompletion = true
        layer.add(glowPulse, forKey: "glowPulse")
    }

    // MARK: - Touch Animations

    @objc private func touchDown() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            self.layer.shadowRadius = 8
            self.layer.shadowOpacity = 0.3
        }
    }

    @objc private func touchUp() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.45,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut
        ) {
            self.transform = .identity
            self.layer.shadowRadius = 14
            self.layer.shadowOpacity = 0.6
        }
    }
}
