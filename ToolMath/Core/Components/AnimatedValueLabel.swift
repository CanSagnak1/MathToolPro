//
//  AnimatedValueLabel.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class AnimatedValueLabel: UILabel {

    func setValue(_ value: String, animated: Bool = true) {
        guard animated else {
            text = value
            return
        }

        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        ) { _ in

            self.text = value

            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95).translatedBy(x: 0, y: 10)

            UIView.animate(
                withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5, options: [.curveEaseOut]
            ) {
                self.alpha = 1
                self.transform = .identity
            }
        }
    }
}