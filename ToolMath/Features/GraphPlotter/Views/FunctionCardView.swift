//
//  FunctionCardView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class FunctionCardView: UIView {

    var onToggleVisibility: (() -> Void)?
    var onDelete: (() -> Void)?

    private let colorDot: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()

    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.mono(size: 15)
        label.textColor = .white
        return label
    }()

    private let visibilityButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        return btn
    }()

    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        btn.tintColor = .systemRed
        return btn
    }()

    private var isVisible = true

    init(expression: String, color: UIColor) {
        super.init(frame: .zero)

        expressionLabel.text = "f(x) = \(expression)"
        colorDot.backgroundColor = color

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 1, alpha: 0.05)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 1, alpha: 0.1).cgColor

        addSubview(colorDot)
        addSubview(expressionLabel)
        addSubview(visibilityButton)
        addSubview(deleteButton)

        colorDot.translatesAutoresizingMaskIntoConstraints = false
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        visibilityButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorDot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            colorDot.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorDot.widthAnchor.constraint(equalToConstant: 12),
            colorDot.heightAnchor.constraint(equalToConstant: 12),

            expressionLabel.leadingAnchor.constraint(
                equalTo: colorDot.trailingAnchor, constant: 12),
            expressionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            expressionLabel.trailingAnchor.constraint(
                equalTo: visibilityButton.leadingAnchor, constant: -8),

            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalToConstant: 32),

            visibilityButton.trailingAnchor.constraint(
                equalTo: deleteButton.leadingAnchor, constant: -4),
            visibilityButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            visibilityButton.widthAnchor.constraint(equalToConstant: 32),
            visibilityButton.heightAnchor.constraint(equalToConstant: 32),

            heightAnchor.constraint(equalToConstant: 52),
        ])

        updateVisibilityIcon()

        visibilityButton.addAction(
            UIAction { [weak self] _ in
                self?.toggleVisibility()
            }, for: .touchUpInside)

        deleteButton.addAction(
            UIAction { [weak self] _ in
                self?.handleDelete()
            }, for: .touchUpInside)
    }

    private func toggleVisibility() {
        isVisible.toggle()
        updateVisibilityIcon()

        UIView.animate(withDuration: 0.2) {
            self.expressionLabel.alpha = self.isVisible ? 1 : 0.4
            self.colorDot.alpha = self.isVisible ? 1 : 0.3
        }

        HapticManager.shared.selection()
        onToggleVisibility?()
    }

    private func updateVisibilityIcon() {
        let iconName = isVisible ? "eye.fill" : "eye.slash.fill"
        visibilityButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    private func handleDelete() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        ) { _ in
            self.onDelete?()
        }

        HapticManager.shared.impact()
    }

    func setVisible(_ visible: Bool, animated: Bool = false) {
        isVisible = visible
        updateVisibilityIcon()

        let update = {
            self.expressionLabel.alpha = visible ? 1 : 0.4
            self.colorDot.alpha = visible ? 1 : 0.3
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: update)
        } else {
            update()
        }
    }
}