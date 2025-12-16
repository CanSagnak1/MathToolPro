//
//  AnimatedToggleSwitch.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class AnimatedToggleSwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }

    private func setupAppearance() {
        onTintColor = Theme.Colors.primary

        layer.shadowColor = Theme.Colors.primary.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero

        addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
    }

    @objc private func valueDidChange() {
        animateGlow()
        HapticManager.shared.selection()
    }

    private func animateGlow() {
        UIView.animate(withDuration: 0.3) {
            self.layer.shadowOpacity = self.isOn ? 0.5 : 0
        }
    }

    override var isOn: Bool {
        didSet {
            animateGlow()
        }
    }
}