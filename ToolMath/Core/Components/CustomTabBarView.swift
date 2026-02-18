//
//  CustomTabBarView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

protocol CustomTabBarViewDelegate: AnyObject {
    func customTabBar(_ tabBar: CustomTabBarView, didSelectTabAt index: Int)
}

final class CustomTabBarView: UIView {

    // MARK: - Properties

    weak var delegate: CustomTabBarViewDelegate?

    private var shapeLayer: CAShapeLayer?
    private var borderGradientLayer: CAGradientLayer?

    private let centerButton = CenterActionButton()
    private var tabItemViews: [TabBarItemView] = []

    private var selectedIndex: Int = 0

    // MARK: - Configuration

    struct ItemConfig {
        let icon: String
        let title: String
    }

    private let items: [ItemConfig]
    private let centerButtonIndex: Int = 2

    private let notchRadius: CGFloat = 40
    private let notchDepth: CGFloat = 32
    private let tabBarHeight: CGFloat = 64  // Taller than standard 49 for premium feel

    // MARK: - Init

    init(items: [ItemConfig], frame: CGRect = .zero) {
        self.items = items
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear

        // 1. Center Button
        addSubview(centerButton)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),  // Raised
            centerButton.widthAnchor.constraint(equalToConstant: 64),
            centerButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)

        // 2. Tab Items
        setupTabItems()
    }

    private func setupTabItems() {
        // Create views
        for (index, item) in items.enumerated() {
            guard index != centerButtonIndex else {
                // Gap for center button
                tabItemViews.append(
                    TabBarItemView(config: .init(iconName: "", title: "", tag: index)))  // Placeholder
                continue
            }

            let itemView = TabBarItemView(
                config: .init(iconName: item.icon, title: item.title, tag: index))
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.onTap = { [weak self] in
                self?.selectTab(at: index)
            }
            addSubview(itemView)
            tabItemViews.append(itemView)
        }

        // Layout Items
        // We arrange them in a row, skipping the center slot visuals
        let totalSlots = items.count

        for (index, view) in tabItemViews.enumerated() {
            guard index != centerButtonIndex else { continue }

            // Calculate position
            // Slot fraction: 0.5, 1.5, 2.5, 3.5, 4.5
            let slotFraction = CGFloat(index) + 0.5

            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(
                    equalTo: widthAnchor, multiplier: 1.0 / CGFloat(totalSlots)),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                view.heightAnchor.constraint(equalToConstant: 50),  // Standard touch area height
            ])

            let centerXConstraint = NSLayoutConstraint(
                item: view,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,  // Using trailing as reference 1.0
                multiplier: slotFraction / CGFloat(totalSlots),
                constant: 0
            )
            centerXConstraint.isActive = true
        }
    }

    // MARK: - Actions

    func selectTab(at index: Int) {
        guard index != selectedIndex || index == centerButtonIndex else { return }

        // Update UI
        for (i, view) in tabItemViews.enumerated() {
            view.isSelected = (i == index)
        }

        selectedIndex = index
        delegate?.customTabBar(self, didSelectTabAt: index)

        // Haptic
        if AppSettings.load().hapticFeedbackEnabled {
            TouchFeedbackEngine.shared.selection()
        }
    }

    @objc private func centerButtonTapped() {
        selectTab(at: centerButtonIndex)
        centerButton.startPulseAnimation()
    }

    // MARK: - Hit Test

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check center button (it might be outside bounds due to raise)
        let convertedPoint = convert(point, to: centerButton)
        if centerButton.bounds.contains(convertedPoint) {
            return centerButton
        }
        return super.hitTest(point, with: event)
    }

    // MARK: - Drawing (Layers)

    private func updateLayers() {
        let path = createNotchedPath()

        if let existing = shapeLayer {
            existing.path = path
            existing.frame = bounds
        } else {
            let shape = CAShapeLayer()
            shape.path = path
            shape.fillColor = Theme.Colors.background.withAlphaComponent(0.98).cgColor
            shape.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
            shape.lineWidth = 0.5
            shape.shadowColor = UIColor.black.cgColor
            shape.shadowOffset = CGSize(width: 0, height: -2)
            shape.shadowOpacity = 0.4
            shape.shadowRadius = 12

            layer.insertSublayer(shape, at: 0)
            shapeLayer = shape

            addBlurOverlay(shape: shape)
        }

        buildTopGlowLine()
    }

    private func buildTopGlowLine() {
        let lineHeight: CGFloat = 1.0
        let lineFrame = CGRect(x: 0, y: 0, width: bounds.width, height: lineHeight)

        if let existing = borderGradientLayer {
            existing.frame = lineFrame
        } else {
            let gradient = CAGradientLayer()
            gradient.frame = lineFrame
            gradient.colors = [
                Theme.Colors.primary.withAlphaComponent(0.0).cgColor,
                Theme.Colors.primary.withAlphaComponent(0.7).cgColor,
                Theme.Colors.primary.withAlphaComponent(0.9).cgColor,
                Theme.Colors.primary.withAlphaComponent(0.7).cgColor,
                Theme.Colors.primary.withAlphaComponent(0.0).cgColor,
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            layer.addSublayer(gradient)
            borderGradientLayer = gradient
        }
    }

    private func addBlurOverlay(shape: CAShapeLayer) {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = false

        let mask = CAShapeLayer()
        mask.path = createNotchedPath()
        blurView.layer.mask = mask

        insertSubview(blurView, at: 1)  // Above shape, below content
    }

    private func createNotchedPath() -> CGPath {
        let path = UIBezierPath()
        let width = bounds.width
        // Calculate height based on bounds.
        // We want the bar to start "0" at top.
        // The bounds will include safety area bottom.

        // Define the notch geometry relative to top center
        let centerX = width / 2
        let r = notchRadius
        let depth = notchDepth

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerX - r - 12, y: 0))

        // Left curve
        path.addCurve(
            to: CGPoint(x: centerX - r + 8, y: depth * 0.55),
            controlPoint1: CGPoint(x: centerX - r + 2, y: 0),
            controlPoint2: CGPoint(x: centerX - r - 4, y: depth * 0.55)
        )

        // Bottom arc
        path.addCurve(
            to: CGPoint(x: centerX + r - 8, y: depth * 0.55),
            controlPoint1: CGPoint(x: centerX - 18, y: depth * 1.2),
            controlPoint2: CGPoint(x: centerX + 18, y: depth * 1.2)
        )

        // Right curve
        path.addCurve(
            to: CGPoint(x: centerX + r + 12, y: 0),
            controlPoint1: CGPoint(x: centerX + r + 4, y: depth * 0.55),
            controlPoint2: CGPoint(x: centerX + r - 2, y: 0)
        )

        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()

        return path.cgPath
    }
}
