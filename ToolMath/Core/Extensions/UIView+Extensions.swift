//
//  UIView+Extensions.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

extension UIView {
    func addGlow(color: UIColor = Theme.Colors.primary, opacity: Float = 0.5, radius: CGFloat = 10)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true

        if let window = self.window {
            layer.rasterizationScale = window.screen.scale
        } else {
            layer.rasterizationScale = 3.0
        }
    }

    func applyGlassEffect() {
        backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = layer.cornerRadius
        blurView.clipsToBounds = true
        insertSubview(blurView, at: 0)

        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
    }

    func pulse(scale: CGFloat = 1.05, duration: TimeInterval = Theme.Animation.fast) {
        UIView.animate(withDuration: duration, delay: 0, options: [.autoreverse, .curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            self.transform = .identity
        }
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}