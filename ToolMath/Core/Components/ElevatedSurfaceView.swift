//
//  ElevatedSurfaceView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class ElevatedSurfaceView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = Theme.Colors.surfaceCard
        layer.cornerRadius = Theme.CornerRadius.card
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.05).cgColor
        layer.masksToBounds = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
    }
}