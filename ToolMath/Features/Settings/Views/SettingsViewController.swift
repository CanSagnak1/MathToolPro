//
//  SettingsViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import UIKit

class SettingsViewController: UIViewController {

    private let viewModel = SettingsViewModel()
    private var cancellables = Set<AnyCancellable>()

    private var expandedSections: Set<String> = ["APPEARANCE"]

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.04, green: 0.05, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.10, green: 0.12, blue: 0.23, alpha: 1).cgColor,
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
    }()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private var sectionContainers: [String: UIView] = [:]
    private var sectionHeaders: [String: SettingsSectionHeaderView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        layout()
        buildSections()
        setupBindings()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupGradient() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
    }

    private func layout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
        ])
    }

    private func buildSections() {
        buildAppearanceSection()
        buildCalculationSection()
        buildGraphSection()
        buildConverterSection()
        buildDataManagementSection()
        buildAdvancedSection()
        buildAboutSection()
        buildResetSection()
    }

    private func createSection(title: String, items: [UIView]) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let card = GlassMorphismCard()

        let header = SettingsSectionHeaderView(title: title)
        sectionHeaders[title] = header

        let itemsStack = UIStackView(arrangedSubviews: items)
        itemsStack.axis = .vertical
        itemsStack.spacing = 0

        let contentStack = UIStackView(arrangedSubviews: [header, itemsStack])
        contentStack.axis = .vertical
        contentStack.spacing = 8

        card.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
        ])

        container.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: container.topAnchor),
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        header.onTap = { [weak self, weak itemsStack] in
            self?.toggleSection(title, itemsStack: itemsStack)
        }

        itemsStack.isHidden = !expandedSections.contains(title)
        header.setExpanded(expandedSections.contains(title), animated: false)

        sectionContainers[title] = itemsStack

        return container
    }

    private func toggleSection(_ title: String, itemsStack: UIStackView?) {
        if expandedSections.contains(title) {
            expandedSections.remove(title)
        } else {
            expandedSections.insert(title)
        }

        let isExpanded = expandedSections.contains(title)

        UIView.animate(
            withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5
        ) {
            itemsStack?.isHidden = !isExpanded
            itemsStack?.alpha = isExpanded ? 1 : 0
        }
    }

    private func createSettingRow(title: String, control: UIView) -> UIView {
        let row = UIView()
        row.backgroundColor = UIColor(white: 1, alpha: 0.02)
        row.layer.cornerRadius = 8

        let label = UILabel()
        label.text = title
        label.font = Theme.Fonts.display(size: 14, weight: .medium)
        label.textColor = .white

        row.addSubview(label)
        row.addSubview(control)

        label.translatesAutoresizingMaskIntoConstraints = false
        control.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: control.leadingAnchor, constant: -8),

            control.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12),
            control.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            row.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])

        return row
    }

    private func buildAppearanceSection() {
        let hapticToggle = AnimatedToggleSwitch()
        hapticToggle.isOn = viewModel.hapticFeedbackEnabled
        hapticToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.hapticFeedbackEnabledChange.send(hapticToggle.isOn)
            }, for: .valueChanged)

        let animSpeed = UISegmentedControl(items: ["Slow", "Normal", "Fast"])
        animSpeed.selectedSegmentIndex = 1
        animSpeed.addAction(
            UIAction { [weak self] _ in
                let speeds: [AnimationSpeed] = [.slow, .normal, .fast]
                self?.viewModel.animationSpeedChange.send(speeds[animSpeed.selectedSegmentIndex])
            }, for: .valueChanged)

        let section = createSection(
            title: "APPEARANCE",
            items: [
                createSettingRow(title: "Haptic Feedback", control: hapticToggle),
                createSettingRow(title: "Animation Speed", control: animSpeed),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildCalculationSection() {
        let angleMode = UISegmentedControl(items: ["Degrees", "Radians"])
        angleMode.selectedSegmentIndex = 0

        let decimalStepper = UIStepper()
        decimalStepper.minimumValue = 0
        decimalStepper.maximumValue = 10
        decimalStepper.value = 4

        let sciToggle = AnimatedToggleSwitch()
        let thousandsToggle = AnimatedToggleSwitch()

        let section = createSection(
            title: "CALCULATION",
            items: [
                createSettingRow(title: "Angle Mode", control: angleMode),
                createSettingRow(title: "Decimal Places", control: decimalStepper),
                createSettingRow(title: "Scientific Notation", control: sciToggle),
                createSettingRow(title: "Thousands Separator", control: thousandsToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildGraphSection() {
        let zoomStepper = UIStepper()
        let thicknessControl = UISegmentedControl(items: ["Thin", "Medium", "Thick"])
        let gridControl = UISegmentedControl(items: ["Low", "Med", "High"])
        let axesToggle = AnimatedToggleSwitch()

        let section = createSection(
            title: "GRAPH PLOTTER",
            items: [
                createSettingRow(title: "Default Zoom", control: zoomStepper),
                createSettingRow(title: "Line Thickness", control: thicknessControl),
                createSettingRow(title: "Grid Density", control: gridControl),
                createSettingRow(title: "Show Axes", control: axesToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildConverterSection() {
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle("Length", for: .normal)
        categoryButton.setTitleColor(Theme.Colors.primary, for: .normal)

        let autoToggle = AnimatedToggleSwitch()

        let section = createSection(
            title: "CONVERTER",
            items: [
                createSettingRow(title: "Default Category", control: categoryButton),
                createSettingRow(title: "Auto-convert", control: autoToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildDataManagementSection() {
        let clearCalcBtn = createActionButton(
            title: "Clear Calculator History", color: .systemOrange)
        let clearConvBtn = createActionButton(
            title: "Clear Converter History", color: .systemOrange)
        let clearAllBtn = createActionButton(title: "Clear All Data", color: .systemRed)

        let section = createSection(
            title: "DATA MANAGEMENT", items: [clearCalcBtn, clearConvBtn, clearAllBtn])
        contentStack.addArrangedSubview(section)
    }

    private func buildAdvancedSection() {
        let developerToggle = AnimatedToggleSwitch()
        let performanceToggle = AnimatedToggleSwitch()

        let section = createSection(
            title: "ADVANCED",
            items: [
                createSettingRow(title: "Developer Mode", control: developerToggle),
                createSettingRow(title: "Performance Mode", control: performanceToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildAboutSection() {
        let versionLabel = createInfoLabel(text: "Version 1.0.0")
        let buildLabel = createInfoLabel(text: "Build 100")

        let section = createSection(title: "ABOUT", items: [versionLabel, buildLabel])
        contentStack.addArrangedSubview(section)
    }

    private func buildResetSection() {
        let resetBtn = createActionButton(title: "Reset All Settings", color: .systemRed)
        let section = createSection(title: "RESET", items: [resetBtn])
        contentStack.addArrangedSubview(section)
    }

    private func createActionButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel?.font = Theme.Fonts.display(size: 14, weight: .semibold)
        btn.backgroundColor = color.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }

    private func createInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Theme.Fonts.display(size: 14)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }

    private func setupBindings() {

    }
}