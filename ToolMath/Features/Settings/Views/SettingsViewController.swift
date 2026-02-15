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

    private let gradientLayer = Theme.makeBackgroundGradient()

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
        angleMode.selectedSegmentIndex = viewModel.angleMode == .degrees ? 0 : 1
        angleMode.addAction(
            UIAction { [weak self] _ in
                let modes: [AngleMode] = [.degrees, .radians]
                self?.viewModel.angleModeChange.send(modes[angleMode.selectedSegmentIndex])
            }, for: .valueChanged)

        let decimalLabel = UILabel()
        decimalLabel.text = "\(viewModel.decimalPlaces)"
        decimalLabel.textColor = Theme.Colors.primary
        decimalLabel.font = Theme.Fonts.display(size: 14, weight: .bold)

        let decimalStepper = UIStepper()
        decimalStepper.minimumValue = 0
        decimalStepper.maximumValue = 10
        decimalStepper.value = Double(viewModel.decimalPlaces)
        decimalStepper.addAction(
            UIAction { [weak self] _ in
                let val = Int(decimalStepper.value)
                decimalLabel.text = "\(val)"
                self?.viewModel.decimalPlacesChange.send(val)
            }, for: .valueChanged)

        let decimalRow = UIStackView(arrangedSubviews: [decimalLabel, decimalStepper])
        decimalRow.spacing = 8
        decimalRow.alignment = .center

        let sciToggle = AnimatedToggleSwitch()
        sciToggle.isOn = viewModel.scientificNotationEnabled
        sciToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.scientificNotationChange.send(sciToggle.isOn)
            }, for: .valueChanged)

        let thousandsToggle = AnimatedToggleSwitch()
        thousandsToggle.isOn = viewModel.thousandsSeparatorEnabled
        thousandsToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.thousandsSeparatorChange.send(thousandsToggle.isOn)
            }, for: .valueChanged)

        let section = createSection(
            title: "CALCULATION",
            items: [
                createSettingRow(title: "Angle Mode", control: angleMode),
                createSettingRow(title: "Decimal Places", control: decimalRow),
                createSettingRow(title: "Scientific Notation", control: sciToggle),
                createSettingRow(title: "Thousands Separator", control: thousandsToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildGraphSection() {
        let zoomLabel = UILabel()
        zoomLabel.text = String(format: "%.0f", viewModel.defaultZoomLevel)
        zoomLabel.textColor = Theme.Colors.primary
        zoomLabel.font = Theme.Fonts.display(size: 14, weight: .bold)

        let zoomStepper = UIStepper()
        zoomStepper.minimumValue = 1
        zoomStepper.maximumValue = 20
        zoomStepper.value = viewModel.defaultZoomLevel
        zoomStepper.addAction(
            UIAction { [weak self] _ in
                let val = zoomStepper.value
                zoomLabel.text = String(format: "%.0f", val)
                self?.viewModel.defaultZoomChange.send(val)
            }, for: .valueChanged)

        let zoomRow = UIStackView(arrangedSubviews: [zoomLabel, zoomStepper])
        zoomRow.spacing = 8
        zoomRow.alignment = .center

        let thicknessControl = UISegmentedControl(items: ["Thin", "Medium", "Thick"])
        let thicknesses: [LineThickness] = [.thin, .medium, .thick]
        thicknessControl.selectedSegmentIndex =
            thicknesses.firstIndex(of: viewModel.graphLineThickness) ?? 1
        thicknessControl.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.lineThicknessChange.send(
                    thicknesses[thicknessControl.selectedSegmentIndex])
            }, for: .valueChanged)

        let gridControl = UISegmentedControl(items: ["Low", "Med", "High"])
        let grids: [GridDensity] = [.low, .medium, .high]
        gridControl.selectedSegmentIndex = grids.firstIndex(of: viewModel.graphGridDensity) ?? 1
        gridControl.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.gridDensityChange.send(grids[gridControl.selectedSegmentIndex])
            }, for: .valueChanged)

        let axesToggle = AnimatedToggleSwitch()
        axesToggle.isOn = viewModel.graphShowAxes
        axesToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.showAxesChange.send(axesToggle.isOn)
            }, for: .valueChanged)

        let section = createSection(
            title: "GRAPH PLOTTER",
            items: [
                createSettingRow(title: "Default Zoom", control: zoomRow),
                createSettingRow(title: "Line Thickness", control: thicknessControl),
                createSettingRow(title: "Grid Density", control: gridControl),
                createSettingRow(title: "Show Axes", control: axesToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildConverterSection() {
        let categoryButton = UIButton(type: .system)
        categoryButton.setTitle(viewModel.converterDefaultCategory.displayName, for: .normal)
        categoryButton.setTitleColor(Theme.Colors.primary, for: .normal)

        let categories = ConversionCategoryDefault.allCases
        let menuActions = categories.map { cat in
            UIAction(title: cat.displayName) { [weak self] _ in
                categoryButton.setTitle(cat.displayName, for: .normal)
                self?.viewModel.defaultCategoryChange.send(cat)
            }
        }
        categoryButton.menu = UIMenu(children: menuActions)
        categoryButton.showsMenuAsPrimaryAction = true

        let autoToggle = AnimatedToggleSwitch()
        autoToggle.isOn = viewModel.converterAutoConvert
        autoToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.autoConvertChange.send(autoToggle.isOn)
            }, for: .valueChanged)

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
        clearCalcBtn.addAction(
            UIAction { [weak self] _ in
                self?.showConfirmation(
                    title: "Clear Calculator History?", message: "This cannot be undone."
                ) {
                    self?.viewModel.clearCalculatorHistoryTrigger.send()
                    HapticManager.shared.notification(.success)
                }
            }, for: .touchUpInside)

        let clearConvBtn = createActionButton(
            title: "Clear Converter History", color: .systemOrange)
        clearConvBtn.addAction(
            UIAction { [weak self] _ in
                self?.showConfirmation(
                    title: "Clear Converter History?", message: "This cannot be undone."
                ) {
                    self?.viewModel.clearConverterHistoryTrigger.send()
                    HapticManager.shared.notification(.success)
                }
            }, for: .touchUpInside)

        let clearAllBtn = createActionButton(title: "Clear All Data", color: .systemRed)
        clearAllBtn.addAction(
            UIAction { [weak self] _ in
                self?.showConfirmation(
                    title: "Clear All Data?", message: "All history will be permanently deleted."
                ) {
                    self?.viewModel.clearAllDataTrigger.send()
                    HapticManager.shared.notification(.success)
                }
            }, for: .touchUpInside)

        let section = createSection(
            title: "DATA MANAGEMENT", items: [clearCalcBtn, clearConvBtn, clearAllBtn])
        contentStack.addArrangedSubview(section)
    }

    private func buildAdvancedSection() {
        let developerToggle = AnimatedToggleSwitch()
        developerToggle.isOn = viewModel.developerMode
        developerToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.developerModeChange.send(developerToggle.isOn)
            }, for: .valueChanged)

        let performanceToggle = AnimatedToggleSwitch()
        performanceToggle.isOn = viewModel.performanceMode
        performanceToggle.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.performanceModeChange.send(performanceToggle.isOn)
            }, for: .valueChanged)

        let section = createSection(
            title: "ADVANCED",
            items: [
                createSettingRow(title: "Developer Mode", control: developerToggle),
                createSettingRow(title: "Performance Mode", control: performanceToggle),
            ])
        contentStack.addArrangedSubview(section)
    }

    private func buildAboutSection() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

        let versionLabel = createInfoLabel(text: "Version \(version)")
        let buildLabel = createInfoLabel(text: "Build \(build)")

        let section = createSection(title: "ABOUT", items: [versionLabel, buildLabel])
        contentStack.addArrangedSubview(section)
    }

    private func buildResetSection() {
        let resetBtn = createActionButton(title: "Reset All Settings", color: .systemRed)
        resetBtn.addAction(
            UIAction { [weak self] _ in
                self?.showConfirmation(
                    title: "Reset All Settings?", message: "All settings will return to defaults."
                ) {
                    self?.viewModel.resetSettingsTrigger.send()
                    HapticManager.shared.refreshSettings()
                    HapticManager.shared.notification(.success)
                    // Rebuild UI with reset values
                    self?.contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    self?.buildSections()
                }
            }, for: .touchUpInside)

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

    private func showConfirmation(title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { _ in action() })
        present(alert, animated: true)
    }

    private func setupBindings() {
        viewModel.hapticFeedbackEnabledChange.sink { _ in
            HapticManager.shared.refreshSettings()
        }.store(in: &cancellables)
    }
}
