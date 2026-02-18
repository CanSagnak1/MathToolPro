//
//  TabBarItemView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

final class TabBarItemView: UIView {

    // MARK: - Public

    struct Configuration {
        let iconName: String
        let title: String
        let tag: Int
    }

    var isSelected: Bool = false {
        didSet { animateStateChange() }
    }

    var onTap: (() -> Void)?

    // MARK: - Subviews

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.Fonts.display(size: 10, weight: .semibold)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let activeIndicator: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.Colors.primary
        v.layer.cornerRadius = 2
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(config: Configuration) {
        super.init(frame: .zero)
        tag = config.tag
        setupView(config: config)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView(config: Configuration) {
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium
        )
        iconImageView.image = UIImage(
            systemName: config.iconName,
            withConfiguration: symbolConfig
        )
        titleLabel.text = config.title

        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(titleLabel)
        addSubview(containerStack)
        addSubview(activeIndicator)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            containerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),

            activeIndicator.topAnchor.constraint(equalTo: containerStack.bottomAnchor, constant: 4),
            activeIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activeIndicator.widthAnchor.constraint(equalToConstant: 4),
            activeIndicator.heightAnchor.constraint(equalToConstant: 4),
        ])

        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @objc private func handleTap() {
        onTap?()
    }

    // MARK: - Animation

    private func animateStateChange() {
        let targetColor = isSelected ? Theme.Colors.primary : UIColor.lightGray  // Lighter for visibility
        let targetScale: CGFloat = isSelected ? 1.0 : 1.0
        let indicatorAlpha: CGFloat = isSelected ? 1.0 : 0.0

        // Bounce on selection
        if isSelected {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: .curveEaseOut
            ) {
                self.containerStack.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            } completion: { _ in
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.3,
                    options: .curveEaseInOut
                ) {
                    self.containerStack.transform = CGAffineTransform(
                        scaleX: targetScale, y: targetScale)
                }
            }
        } else {
            UIView.animate(withDuration: Theme.Animation.fast) {
                self.containerStack.transform = .identity
            }
        }

        // Color transition
        UIView.animate(withDuration: Theme.Animation.normal) {
            self.iconImageView.tintColor = targetColor
            self.titleLabel.textColor = targetColor
            self.activeIndicator.alpha = indicatorAlpha
        }
    }
}
