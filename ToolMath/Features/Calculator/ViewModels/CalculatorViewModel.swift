//
//  CalculatorViewModel.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import Foundation

class CalculatorViewModel {

    private var cancellables = Set<AnyCancellable>()

    let buttonPress = PassthroughSubject<String, Never>()

    @Published var display: String = "0"
    @Published var expressionPreview: String = ""
    @Published var history: [CalculationHistory] = []

    private var currentExpression = ""
    private var isNewCalculation = true

    private let historyKey = "calculator_history"

    init() {
        buttonPress
            .sink { [weak self] btn in
                self?.handleInput(btn)
            }
            .store(in: &cancellables)

        loadHistory()
    }

    private func handleInput(_ btn: String) {
        if isNewCalculation && isDigit(btn) {
            currentExpression = ""
            isNewCalculation = false
        }

        switch btn {
        case "AC":
            currentExpression = ""
            display = "0"
            expressionPreview = ""
        case "=":
            evaluate()
        case "backspace":
            if !currentExpression.isEmpty {
                currentExpression.removeLast()
                display = currentExpression.isEmpty ? "0" : currentExpression
            }
        case "sin", "cos", "tan":

            let settings = AppSettings.load()
            if settings.angleMode == .degrees {
                currentExpression += "\(btn)(π/180*"
            } else {
                currentExpression += "\(btn)("
            }
            display = currentExpression
        case "log", "ln":
            currentExpression += btn + "("
            display = currentExpression
        case "√":
            currentExpression += "sqrt("
            display = currentExpression
        case "π":
            currentExpression += "π"
            display = currentExpression
        case "e":
            currentExpression += "e"
            display = currentExpression
        case "×":
            currentExpression += "×"
            display = currentExpression
        case "÷":
            currentExpression += "÷"
            display = currentExpression
        case "x²":
            currentExpression += "^2"
            display = currentExpression
        case "%":
            if let value = Double(currentExpression) {
                currentExpression = String(value / 100)
                display = currentExpression
            }
        default:
            currentExpression += btn
            display = currentExpression
        }
    }

    private func evaluate() {
        let result = MathExpressionEvaluator.evaluate(currentExpression)

        switch result {
        case .success(let value):
            let resString = formatResult(value)

            let newHistory = CalculationHistory(
                expression: currentExpression,
                result: resString
            )
            history.insert(newHistory, at: 0)
            if history.count > 20 {
                history = Array(history.prefix(20))
            }
            saveHistory()

            display = resString
            expressionPreview = currentExpression
            currentExpression = resString
            isNewCalculation = true

        case .failure(_):
            display = "Error"
            expressionPreview = currentExpression
            isNewCalculation = true
        }
    }

    private func formatResult(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }

        let settings = AppSettings.load()

        if settings.scientificNotationEnabled {
            if abs(value) < 0.0001 && value != 0 {
                return String(format: "%.2e", value)
            }
            if abs(value) > 1_000_000_000 {
                return String(format: "%.2e", value)
            }
        }

        let formatted = String(format: "%.\(settings.decimalPlaces)f", value)
        var trimmed = formatted.replacingOccurrences(
            of: #"\.?0+$"#, with: "", options: .regularExpression)

        if settings.thousandsSeparatorEnabled, let doubleValue = Double(trimmed) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = settings.decimalPlaces
            formatter.groupingSeparator = ","
            if let formattedWithSeparator = formatter.string(from: NSNumber(value: doubleValue)) {
                trimmed = formattedWithSeparator
            }
        }

        return trimmed
    }

    private func isDigit(_ val: String) -> Bool {
        return Int(val) != nil || val == "."
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
            let loadedHistory = try? JSONDecoder().decode([CalculationHistory].self, from: data)
        {
            history = loadedHistory
        }
    }
}