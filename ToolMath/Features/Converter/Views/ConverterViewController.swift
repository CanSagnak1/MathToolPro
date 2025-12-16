//
//  ConverterViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import UIKit

class ConverterViewController: UIViewController {

    private let viewModel = ConverterViewModel()
    private var cancellables = Set<AnyCancellable>()

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Converter"
        label.font = Theme.Fonts.display(size: 28, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let categoryScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return scroll
    }()

    private let categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    private let conversionCard = GlassMorphismCard()

    private let fromValueLabel: AnimatedValueLabel = {
        let label = AnimatedValueLabel()
        label.font = Theme.Fonts.display(size: 52, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private let fromUnitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = Theme.Fonts.display(size: 16, weight: .medium)
        btn.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.down.circle.fill")
            config.imagePlacement = .trailing
            config.imagePadding = 8
            btn.configuration = config
        }

        return btn
    }()

    private let swapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.up.arrow.down.circle.fill"), for: .normal)
        btn.tintColor = Theme.Colors.primary
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()

    private let toValueLabel: AnimatedValueLabel = {
        let label = AnimatedValueLabel()
        label.font = Theme.Fonts.display(size: 52, weight: .bold)
        label.textColor = Theme.Colors.primary
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private let toUnitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = Theme.Fonts.display(size: 16, weight: .medium)
        btn.setTitleColor(Theme.Colors.primary.withAlphaComponent(0.8), for: .normal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.down.circle.fill")
            config.imagePlacement = .trailing
            config.imagePadding = 8
            btn.configuration = config
        }

        return btn
    }()

    private let keypadContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        layout()
        setupBindings()
        setupActions()
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
        view.addSubview(titleLabel)
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStack)

        view.addSubview(conversionCard)
        conversionCard.addSubview(fromValueLabel)
        conversionCard.addSubview(fromUnitButton)
        conversionCard.addSubview(swapButton)
        conversionCard.addSubview(toValueLabel)
        conversionCard.addSubview(toUnitButton)

        view.addSubview(keypadContainer)

        setupCategories()
        setupKeypad()
    }

    private func setupCategories() {
        for category in ConversionCategory.allCases {
            let btn = createCategoryPill(category)
            categoryStack.addArrangedSubview(btn)
        }
    }

    private func createCategoryPill(_ category: ConversionCategory) -> UIButton {
        let btn = UIButton()

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = category.displayName
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 8, leading: 16, bottom: 8, trailing: 16)
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                incoming in
                var outgoing = incoming
                outgoing.font = Theme.Fonts.display(size: 14, weight: .semibold)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.setTitle(category.displayName, for: .normal)
            btn.titleLabel?.font = Theme.Fonts.display(size: 14, weight: .semibold)
            btn.layer.cornerRadius = 18
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        }

        btn.heightAnchor.constraint(equalToConstant: 36).isActive = true

        updateCategoryPill(btn, isActive: category == viewModel.currentCategory)

        btn.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.categoryChange.send(category)
                self?.animateCategoryChange()
            }, for: .touchUpInside)

        return btn
    }

    private func updateCategoryPill(_ btn: UIButton, isActive: Bool) {
        UIView.animate(
            withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5
        ) {
            if isActive {
                btn.backgroundColor = Theme.Colors.primary
                btn.setTitleColor(.black, for: .normal)
                btn.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } else {
                btn.backgroundColor = UIColor(white: 1, alpha: 0.1)
                btn.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
                btn.transform = .identity
            }
        }
    }

    private func setupKeypad() {
        let rows = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            [".", "0", "⌫"],
        ]

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.distribution = .fillEqually

        for row in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            for key in row {
                let btn = createKeypadButton(key)
                rowStack.addArrangedSubview(btn)
            }
            mainStack.addArrangedSubview(rowStack)
        }

        keypadContainer.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: keypadContainer.topAnchor),
            mainStack.leadingAnchor.constraint(
                equalTo: keypadContainer.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(
                equalTo: keypadContainer.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: keypadContainer.bottomAnchor),
        ])
    }

    private func createKeypadButton(_ key: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(key == "⌫" ? "" : key, for: .normal)

        if key == "⌫" {
            btn.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
            btn.tintColor = .systemRed
        } else {
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = Theme.Fonts.display(size: 24, weight: .medium)
        }

        btn.backgroundColor = UIColor(white: 1, alpha: 0.08)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(white: 1, alpha: 0.12).cgColor

        btn.addAction(
            UIAction { [weak self] _ in
                self?.animateButtonPress(btn)
                let display = key == "⌫" ? "backspace" : key
                self?.viewModel.keypadInput.send(display)
            }, for: .touchUpInside)

        return btn
    }

    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        conversionCard.translatesAutoresizingMaskIntoConstraints = false
        fromValueLabel.translatesAutoresizingMaskIntoConstraints = false
        fromUnitButton.translatesAutoresizingMaskIntoConstraints = false
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        toValueLabel.translatesAutoresizingMaskIntoConstraints = false
        toUnitButton.translatesAutoresizingMaskIntoConstraints = false
        keypadContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 52),

            categoryStack.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStack.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStack.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),

            conversionCard.topAnchor.constraint(
                equalTo: categoryScrollView.bottomAnchor, constant: 24),
            conversionCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            conversionCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            conversionCard.heightAnchor.constraint(equalToConstant: 340),

            fromValueLabel.topAnchor.constraint(equalTo: conversionCard.topAnchor, constant: 32),
            fromValueLabel.leadingAnchor.constraint(
                equalTo: conversionCard.leadingAnchor, constant: 24),
            fromValueLabel.trailingAnchor.constraint(
                equalTo: conversionCard.trailingAnchor, constant: -24),

            fromUnitButton.topAnchor.constraint(equalTo: fromValueLabel.bottomAnchor, constant: 8),
            fromUnitButton.centerXAnchor.constraint(equalTo: conversionCard.centerXAnchor),

            swapButton.centerYAnchor.constraint(equalTo: conversionCard.centerYAnchor),
            swapButton.centerXAnchor.constraint(equalTo: conversionCard.centerXAnchor),
            swapButton.widthAnchor.constraint(equalToConstant: 56),
            swapButton.heightAnchor.constraint(equalToConstant: 56),

            toUnitButton.bottomAnchor.constraint(equalTo: toValueLabel.topAnchor, constant: -8),
            toUnitButton.centerXAnchor.constraint(equalTo: conversionCard.centerXAnchor),

            toValueLabel.leadingAnchor.constraint(
                equalTo: conversionCard.leadingAnchor, constant: 24),
            toValueLabel.trailingAnchor.constraint(
                equalTo: conversionCard.trailingAnchor, constant: -24),
            toValueLabel.bottomAnchor.constraint(
                equalTo: conversionCard.bottomAnchor, constant: -32),

            keypadContainer.topAnchor.constraint(
                equalTo: conversionCard.bottomAnchor, constant: 20),
            keypadContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keypadContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keypadContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    private func setupActions() {
        fromUnitButton.addAction(
            UIAction { [weak self] _ in
                self?.showUnitPicker(isFrom: true)
            }, for: .touchUpInside)

        toUnitButton.addAction(
            UIAction { [weak self] _ in
                self?.showUnitPicker(isFrom: false)
            }, for: .touchUpInside)

        swapButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.swapTrigger.send()
                self?.animateSwap()
            }, for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.$displayValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.fromValueLabel.setValue(value, animated: true)
            }
            .store(in: &cancellables)

        viewModel.$resultValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.toValueLabel.setValue(value, animated: true)
            }
            .store(in: &cancellables)

        viewModel.$fromUnit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] unit in
                self?.fromUnitButton.setTitle(unit.symbol, for: .normal)
            }
            .store(in: &cancellables)

        viewModel.$toUnit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] unit in
                self?.toUnitButton.setTitle(unit.symbol, for: .normal)
            }
            .store(in: &cancellables)

        viewModel.$currentCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAllCategoryPills()
            }
            .store(in: &cancellables)
    }

    private func animateButtonPress(_ button: UIButton) {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                button.alpha = 0.7
            }
        ) { _ in
            UIView.animate(
                withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8
            ) {
                button.transform = .identity
                button.alpha = 1
            }
        }

        HapticManager.shared.selection()
    }

    private func animateSwap() {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5
        ) {
            self.swapButton.transform = self.swapButton.transform.rotated(by: .pi)
        }

        HapticManager.shared.impact()
    }

    private func animateCategoryChange() {
        UIView.animate(withDuration: 0.2) {
            self.conversionCard.alpha = 0
            self.conversionCard.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(
                withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5
            ) {
                self.conversionCard.alpha = 1
                self.conversionCard.transform = .identity
            }
        }

        HapticManager.shared.selection()
    }

    private func updateAllCategoryPills() {
        for (index, category) in ConversionCategory.allCases.enumerated() {
            if let btn = categoryStack.arrangedSubviews[index] as? UIButton {
                updateCategoryPill(btn, isActive: category == viewModel.currentCategory)
            }
        }
    }

    private func showUnitPicker(isFrom: Bool) {
        let alert = UIAlertController(
            title: "Select Unit", message: nil, preferredStyle: .actionSheet)

        for unit in viewModel.currentCategory.units {
            alert.addAction(
                UIAlertAction(title: "\(unit.name) (\(unit.symbol))", style: .default) {
                    [weak self] _ in
                    if isFrom {
                        self?.viewModel.fromUnitChange.send(unit)
                    } else {
                        self?.viewModel.toUnitChange.send(unit)
                    }
                    HapticManager.shared.selection()
                })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}