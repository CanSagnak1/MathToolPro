//
//  CalculatorDisplayView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class CalculatorDisplayView: UIView {

    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 16, weight: .regular)
        label.textColor = UIColor(white: 0.7, alpha: 1)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.text = ""
        return label
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 56, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.text = "0"
        return label
    }()

    private let glassCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.08)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 1, alpha: 0.15).cgColor

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 16
        return view
    }()

    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(glassCard)
        glassCard.addSubview(blurView)
        glassCard.addSubview(expressionLabel)
        glassCard.addSubview(resultLabel)

        glassCard.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            glassCard.topAnchor.constraint(equalTo: topAnchor),
            glassCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassCard.bottomAnchor.constraint(equalTo: bottomAnchor),

            blurView.topAnchor.constraint(equalTo: glassCard.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: glassCard.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: glassCard.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: glassCard.bottomAnchor),

            expressionLabel.topAnchor.constraint(equalTo: glassCard.topAnchor, constant: 20),
            expressionLabel.leadingAnchor.constraint(
                equalTo: glassCard.leadingAnchor, constant: 24),
            expressionLabel.trailingAnchor.constraint(
                equalTo: glassCard.trailingAnchor, constant: -24),

            resultLabel.centerYAnchor.constraint(equalTo: glassCard.centerYAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: glassCard.leadingAnchor, constant: 24),
            resultLabel.trailingAnchor.constraint(equalTo: glassCard.trailingAnchor, constant: -24),
        ])
    }

    func updateExpression(_ text: String) {
        expressionLabel.text = text
    }

    func updateResult(_ text: String, animated: Bool = false) {
        if animated {
            let transition = CATransition()
            transition.type = .push
            transition.subtype = .fromBottom
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            resultLabel.layer.add(transition, forKey: "resultTransition")
        }

        resultLabel.text = text
    }

    func showError() {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.values = [0, -10, 10, -10, 10, -5, 5, 0]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 1]
        animation.duration = 0.4
        layer.add(animation, forKey: "shake")

        HapticManager.shared.notification(.error)
    }
}