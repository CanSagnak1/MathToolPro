//
//  KeypadButton.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class KeypadButton: UIButton {
    enum ButtonType {
        case number
        case function
        case action
        case secondary
    }

    let type: ButtonType

    init(title: String, type: ButtonType = .number) {
        self.type = type
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        layer.cornerRadius = Theme.CornerRadius.button
        titleLabel?.font = Theme.Fonts.display(size: 20, weight: .medium)

        switch type {
        case .number:
            backgroundColor = UIColor(white: 1, alpha: 0.05)
            setTitleColor(.white, for: .normal)
        case .function:
            backgroundColor = Theme.Colors.primary.withAlphaComponent(0.1)
            setTitleColor(Theme.Colors.primary, for: .normal)
        case .action:
            backgroundColor = Theme.Colors.primary
            setTitleColor(.black, for: .normal)
            addGlow()
        case .secondary:
            backgroundColor = UIColor(hex: "#1f363b")
            setTitleColor(.lightGray, for: .normal)
        }

        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(
            self, action: #selector(handleTouchUp),
            for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func handleTouchDown() {
        HapticManager.shared.impact(.light)
        UIView.animate(withDuration: Theme.Animation.fast) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }

    @objc private func handleTouchUp() {
        UIView.animate(withDuration: Theme.Animation.fast) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}