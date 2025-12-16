//
//  ConverterViewModel.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import Foundation

class ConverterViewModel {

    private var cancellables = Set<AnyCancellable>()

    let keypadInput = PassthroughSubject<String, Never>()
    let swapTrigger = PassthroughSubject<Void, Never>()
    let categoryChange = PassthroughSubject<ConversionCategory, Never>()
    let fromUnitChange = PassthroughSubject<Unit, Never>()
    let toUnitChange = PassthroughSubject<Unit, Never>()

    @Published var displayValue: String = "1"
    @Published var resultValue: String = "0"
    @Published var currentCategory: ConversionCategory = .length
    @Published var fromUnit: Unit
    @Published var toUnit: Unit
    @Published var history: [ConversionHistory] = []

    private let historyKey = "converter_history"

    init() {
        let lengthUnits = ConversionCategory.length.units
        self.fromUnit = lengthUnits[0]
        self.toUnit = lengthUnits[6]

        setupBindings()
        loadHistory()
    }

    private func setupBindings() {
        keypadInput
            .sink { [weak self] key in
                self?.handleKey(key)
            }
            .store(in: &cancellables)

        $displayValue
            .map { [weak self] val -> String in
                guard let self = self, let num = Double(val) else { return "0" }
                let result = self.fromUnit.convert(value: num, to: self.toUnit)
                return self.formatResult(result)
            }
            .assign(to: &$resultValue)

        swapTrigger
            .sink { [weak self] in
                guard let self = self else { return }
                let temp = self.fromUnit
                self.fromUnit = self.toUnit
                self.toUnit = temp

                let tempValue = self.displayValue
                self.displayValue = self.resultValue
                self.resultValue = tempValue
            }
            .store(in: &cancellables)

        categoryChange
            .sink { [weak self] category in
                guard let self = self else { return }
                self.currentCategory = category
                let units = category.units
                self.fromUnit = units[0]
                self.toUnit = units.count > 1 ? units[1] : units[0]
                self.displayValue = "1"
            }
            .store(in: &cancellables)

        fromUnitChange
            .sink { [weak self] unit in
                self?.fromUnit = unit
            }
            .store(in: &cancellables)

        toUnitChange
            .sink { [weak self] unit in
                self?.toUnit = unit
            }
            .store(in: &cancellables)
    }

    private func handleKey(_ key: String) {
        switch key {
        case "AC":
            displayValue = "0"
        case "backspace":
            if displayValue.count > 1 {
                displayValue.removeLast()
            } else {
                displayValue = "0"
            }
        case "+/-":
            if displayValue.hasPrefix("-") {
                displayValue.removeFirst()
            } else if displayValue != "0" {
                displayValue = "-" + displayValue
            }
        case "check":
            addToHistory()
        case ".":
            if !displayValue.contains(".") {
                displayValue += "."
            }
        default:
            if displayValue == "0" && key != "." {
                displayValue = key
            } else {
                displayValue += key
            }
        }
    }

    private func addToHistory() {
        let newItem = ConversionHistory(
            fromValue: displayValue,
            fromUnit: fromUnit.symbol,
            toValue: resultValue,
            toUnit: toUnit.symbol,
            category: currentCategory.rawValue
        )
        history.insert(newItem, at: 0)
        if history.count > 10 {
            history = Array(history.prefix(10))
        }
        saveHistory()
    }

    private func formatResult(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }

        if abs(value) < 0.001 && value != 0 {
            return String(format: "%.2e", value)
        }

        if abs(value) > 1_000_000 {
            return String(format: "%.2e", value)
        }

        let formatted = String(format: "%.6f", value)
        let trimmed = formatted.replacingOccurrences(
            of: #"\.?0+$"#, with: "", options: .regularExpression)
        return trimmed
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
            let loadedHistory = try? JSONDecoder().decode([ConversionHistory].self, from: data)
        {
            history = loadedHistory
        }
    }
}