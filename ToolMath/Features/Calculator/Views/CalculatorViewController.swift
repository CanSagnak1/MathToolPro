//
//  CalculatorViewController.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import UIKit

class CalculatorViewController: UIViewController {

    private let viewModel = CalculatorViewModel()
    private var cancellables = Set<AnyCancellable>()

    private var isScientificMode = false

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

    private let displayView = CalculatorDisplayView()

    private let modeToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("SCI", for: .normal)
        btn.setTitleColor(Theme.Colors.primary, for: .normal)
        btn.titleLabel?.font = Theme.Fonts.display(size: 16, weight: .bold)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.08)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(white: 1, alpha: 0.15).cgColor
        return btn
    }()

    private let keypadContainer = UIView()
    private var basicKeypad: UIView!
    private var scientificKeypad: UIView!

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
        view.addSubview(displayView)
        view.addSubview(modeToggleButton)
        view.addSubview(keypadContainer)

        basicKeypad = createBasicKeypad()
        scientificKeypad = createScientificKeypad()

        keypadContainer.addSubview(basicKeypad)
        keypadContainer.addSubview(scientificKeypad)

        scientificKeypad.alpha = 0
        scientificKeypad.isHidden = true
    }

    private func createBasicKeypad() -> UIView {
        let container = UIView()

        let buttons: [[String]] = [
            ["AC", "(", ")", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "⌫", "="],
        ]

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.distribution = .fillEqually

        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 14
            rowStack.distribution = .fillEqually

            for title in row {
                let type: CalculatorButton.ButtonType
                if title == "AC" {
                    type = .clear
                } else if title == "=" {
                    type = .equals
                } else if ["÷", "×", "-", "+"].contains(title) {
                    type = .operation
                } else if ["(", ")"].contains(title) {
                    type = .parenthesis
                } else {
                    type = .number
                }

                let btn = CalculatorButton(title: title, type: type)
                btn.addAction(
                    UIAction { [weak self] _ in
                        self?.handleButtonPress(title)
                    }, for: .touchUpInside)

                if title == "=" {
                    btn.addPulsatingGlow()
                }

                rowStack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(rowStack)
        }

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    private func createScientificKeypad() -> UIView {
        let container = UIView()

        let buttons: [[String]] = [
            ["sin", "cos", "tan", "ln", "log"],
            ["π", "e", "x²", "√", "EXP"],
            ["AC", "(", ")", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "⌫", "="],
        ]

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually

        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            for title in row {
                let type: CalculatorButton.ButtonType
                if title == "AC" {
                    type = .clear
                } else if title == "=" {
                    type = .equals
                } else if ["÷", "×", "-", "+"].contains(title) {
                    type = .operation
                } else if [
                    "sin", "cos", "tan", "ln", "log", "π", "e", "x²", "√", "EXP", "%",
                ].contains(title) {
                    type = .function
                } else if ["(", ")"].contains(title) {
                    type = .parenthesis
                } else {
                    type = .number
                }

                let btn = CalculatorButton(title: title, type: type)
                btn.addAction(
                    UIAction { [weak self] _ in
                        self?.handleButtonPress(title)
                    }, for: .touchUpInside)

                if title == "=" {
                    btn.addPulsatingGlow()
                }

                rowStack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(rowStack)
        }

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }

    private func layout() {
        displayView.translatesAutoresizingMaskIntoConstraints = false
        modeToggleButton.translatesAutoresizingMaskIntoConstraints = false
        keypadContainer.translatesAutoresizingMaskIntoConstraints = false
        basicKeypad.translatesAutoresizingMaskIntoConstraints = false
        scientificKeypad.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            displayView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            displayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            displayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            displayView.heightAnchor.constraint(equalToConstant: 250),

            modeToggleButton.topAnchor.constraint(equalTo: displayView.bottomAnchor, constant: 20),
            modeToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeToggleButton.widthAnchor.constraint(equalToConstant: 100),
            modeToggleButton.heightAnchor.constraint(equalToConstant: 40),

            keypadContainer.topAnchor.constraint(
                equalTo: modeToggleButton.bottomAnchor, constant: 24),
            keypadContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            keypadContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            keypadContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            basicKeypad.topAnchor.constraint(equalTo: keypadContainer.topAnchor),
            basicKeypad.leadingAnchor.constraint(equalTo: keypadContainer.leadingAnchor),
            basicKeypad.trailingAnchor.constraint(equalTo: keypadContainer.trailingAnchor),
            basicKeypad.bottomAnchor.constraint(equalTo: keypadContainer.bottomAnchor),

            scientificKeypad.topAnchor.constraint(equalTo: keypadContainer.topAnchor),
            scientificKeypad.leadingAnchor.constraint(equalTo: keypadContainer.leadingAnchor),
            scientificKeypad.trailingAnchor.constraint(equalTo: keypadContainer.trailingAnchor),
            scientificKeypad.bottomAnchor.constraint(equalTo: keypadContainer.bottomAnchor),
        ])
    }

    private func setupActions() {
        modeToggleButton.addAction(
            UIAction { [weak self] _ in
                self?.toggleScientificMode()
            }, for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.$display
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.displayView.updateResult(value, animated: false)
            }
            .store(in: &cancellables)

        viewModel.$expressionPreview
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.displayView.updateExpression(value)
            }
            .store(in: &cancellables)
    }

    private func handleButtonPress(_ title: String) {
        let mappedTitle: String
        switch title {
        case "⌫": mappedTitle = "backspace"
        case "=": mappedTitle = "="
        default: mappedTitle = title
        }

        viewModel.buttonPress.send(mappedTitle)

        if title == "=" {
            displayView.updateResult(viewModel.display, animated: true)
        }

        if viewModel.display == "Error" {
            displayView.showError()
        }
    }

    private func toggleScientificMode() {
        isScientificMode.toggle()

        let outKeypad = isScientificMode ? basicKeypad! : scientificKeypad!
        let inKeypad = isScientificMode ? scientificKeypad! : basicKeypad!

        inKeypad.isHidden = false
        inKeypad.alpha = 0
        inKeypad.transform = CGAffineTransform(translationX: 100, y: 0)

        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.5,
            animations: {
                outKeypad.alpha = 0
                outKeypad.transform = CGAffineTransform(translationX: -100, y: 0)
            }
        ) { _ in
            outKeypad.isHidden = true
            outKeypad.transform = .identity
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0.1,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.5
        ) {
            inKeypad.alpha = 1
            inKeypad.transform = .identity
        }

        UIView.animate(withDuration: 0.25) {
            self.modeToggleButton.setTitle(self.isScientificMode ? "BASIC" : "SCI", for: .normal)
        }

        HapticManager.shared.impact()
    }
}