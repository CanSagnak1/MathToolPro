//
//  SettingsSectionHeaderView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class SettingsSectionHeaderView: UIView {

    var onTap: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.display(size: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let chevronIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.tintColor = Theme.Colors.primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private(set) var isExpanded = true

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 1, alpha: 0.03)
        layer.cornerRadius = 12

        addSubview(titleLabel)
        addSubview(chevronIcon)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            chevronIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 20),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20),

            heightAnchor.constraint(equalToConstant: 50),
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        toggleExpansion()
        onTap?()
    }

    func toggleExpansion(animated: Bool = true) {
        isExpanded.toggle()

        let rotation: CGFloat = isExpanded ? 0 : -.pi / 2

        if animated {
            UIView.animate(
                withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5
            ) {
                self.chevronIcon.transform = CGAffineTransform(rotationAngle: rotation)
            }
        } else {
            chevronIcon.transform = CGAffineTransform(rotationAngle: rotation)
        }

        HapticManager.shared.selection()
    }

    func setExpanded(_ expanded: Bool, animated: Bool = false) {
        guard isExpanded != expanded else { return }
        toggleExpansion(animated: animated)
    }
}