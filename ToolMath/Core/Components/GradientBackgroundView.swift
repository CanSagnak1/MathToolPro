//
//  GradientBackgroundView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class GradientBackgroundView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    init(colors: [UIColor], locations: [NSNumber]? = nil) {
        super.init(frame: .zero)
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}