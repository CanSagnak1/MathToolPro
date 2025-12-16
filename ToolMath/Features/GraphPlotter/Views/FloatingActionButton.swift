//
//  FloatingActionButton.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class FloatingActionButton: UIView {

    var onPrimaryAction: (() -> Void)?
    var onSecondaryActions: ((Int) -> Void)?

    private let mainButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Theme.Colors.primary
        btn.tintColor = .black
        btn.layer.cornerRadius = 28
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 8
        return btn
    }()

    private let plusIcon: UIImageView = {
        let iv = UIImageView(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)))
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private var isExpanded = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(mainButton)
        mainButton.addSubview(plusIcon)

        mainButton.translatesAutoresizingMaskIntoConstraints = false
        plusIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainButton.widthAnchor.constraint(equalToConstant: 56),
            mainButton.heightAnchor.constraint(equalToConstant: 56),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            plusIcon.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor),
        ])

        mainButton.addAction(
            UIAction { [weak self] _ in
                self?.handleTap()
            }, for: .touchUpInside)
    }

    private func handleTap() {
        HapticManager.shared.impact()

        UIView.animate(
            withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5
        ) {
            let rotation = self.isExpanded ? 0 : CGFloat.pi / 4
            self.plusIcon.transform = CGAffineTransform(rotationAngle: rotation)
        }

        isExpanded.toggle()
        onPrimaryAction?()
    }

    func resetToCollapsed() {
        isExpanded = false
        UIView.animate(withDuration: 0.3) {
            self.plusIcon.transform = .identity
        }
    }
}