//
//  FormulaDetailViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import UIKit

class FormulaDetailViewController: UIViewController {

    private let formula: Formula
    private var inputTextFields: [String: UITextField] = [:]

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 24, weight: .bold)
        l.textColor = Theme.Colors.textPrimary
        l.numberOfLines = 0
        return l
    }()

    private let descLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 16, weight: .regular)
        l.textColor = Theme.Colors.secondaryText
        l.numberOfLines = 0
        return l
    }()

    private let inputsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private let calculateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Calculate", for: .normal)
        btn.titleLabel?.font = Theme.Fonts.display(size: 18, weight: .semibold)
        btn.backgroundColor = Theme.Colors.primary
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()

    private let resultCard = ElevatedSurfaceView()
    private let resultLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 32, weight: .bold)
        l.textColor = Theme.Colors.textPrimary
        l.textAlignment = .center
        l.text = "Result"
        return l
    }()

    private let resultUnitLabel: UILabel = {
        let l = UILabel()
        l.font = Theme.Fonts.display(size: 16, weight: .medium)
        l.textColor = Theme.Colors.secondaryText
        l.textAlignment = .center
        return l
    }()

    init(formula: Formula) {
        self.formula = formula
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInputs()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        title = "Calculate"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(inputsStack)
        contentView.addSubview(calculateButton)
        contentView.addSubview(resultCard)

        resultCard.addSubview(resultLabel)
        resultCard.addSubview(resultUnitLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        inputsStack.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        resultCard.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultUnitLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = formula.title
        descLabel.text = formula.description
        resultUnitLabel.text = formula.resultUnit

        calculateButton.addTarget(self, action: #selector(calculateTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            inputsStack.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            inputsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            inputsStack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),

            calculateButton.topAnchor.constraint(equalTo: inputsStack.bottomAnchor, constant: 32),
            calculateButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 50),

            resultCard.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 32),
            resultCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultCard.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),
            resultCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            resultCard.heightAnchor.constraint(equalToConstant: 120),

            resultLabel.centerYAnchor.constraint(equalTo: resultCard.centerYAnchor, constant: -10),
            resultLabel.leadingAnchor.constraint(equalTo: resultCard.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(
                equalTo: resultCard.trailingAnchor, constant: -16),

            resultUnitLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 4),
            resultUnitLabel.centerXAnchor.constraint(equalTo: resultCard.centerXAnchor),
        ])
    }

    private func setupInputs() {
        for input in formula.inputs {
            let container = UIView()

            let label = UILabel()
            label.text = "\(input.name) (\(input.symbol))"
            label.font = Theme.Fonts.display(size: 14, weight: .medium)
            label.textColor = Theme.Colors.textPrimary

            let textField = UITextField()
            textField.borderStyle = .none
            textField.backgroundColor = Theme.Colors.surfaceSecondary
            textField.layer.cornerRadius = 8
            textField.textColor = Theme.Colors.textPrimary
            textField.keyboardType = .decimalPad
            textField.font = Theme.Fonts.mono(size: 16)

            // Padding
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            textField.leftView = paddingView
            textField.leftViewMode = .always

            if let unit = input.unit {
                let unitLabel = UILabel()
                unitLabel.text = " \(unit) "
                unitLabel.textColor = Theme.Colors.secondaryText
                unitLabel.font = Theme.Fonts.display(size: 14)
                textField.rightView = unitLabel
                textField.rightViewMode = .always
            }

            if let def = input.defaultValue {
                textField.text = "\(def)"
            }

            container.addSubview(label)
            container.addSubview(textField)

            label.translatesAutoresizingMaskIntoConstraints = false
            textField.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),

                textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
                textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                textField.heightAnchor.constraint(equalToConstant: 44),
            ])

            inputsStack.addArrangedSubview(container)
            inputTextFields[input.symbol] = textField
        }
    }

    @objc private func calculateTapped() {
        var values: [String: Double] = [:]

        for (symbol, tf) in inputTextFields {
            if let text = tf.text, let val = Double(text) {
                values[symbol] = val
            } else {
                // Show error
                showError("Please enter a valid value for \(symbol)")
                return
            }
        }

        if let result = formula.evaluate(values) {
            resultLabel.text = String(format: "%.2f", result)
            TouchFeedbackEngine.shared.notification(.success)

            // Log to history if needed
            // HistoryService.shared.saveCalculation(...) logic here if desired
        } else {
            showError("Calculation failed make sure inputs are valid.")
            TouchFeedbackEngine.shared.notification(.error)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
