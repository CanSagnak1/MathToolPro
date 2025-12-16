//
//  Unit.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

struct Unit {
    let name: String
    let symbol: String
    let toBase: Double
    let isTemperature: Bool

    init(name: String, symbol: String, toBase: Double, isTemperature: Bool = false) {
        self.name = name
        self.symbol = symbol
        self.toBase = toBase
        self.isTemperature = isTemperature
    }

    func convert(value: Double, to targetUnit: Unit) -> Double {
        if isTemperature && targetUnit.isTemperature {
            return convertTemperature(value, from: self, to: targetUnit)
        }

        let baseValue = value * toBase
        return baseValue / targetUnit.toBase
    }

    private func convertTemperature(_ value: Double, from: Unit, to: Unit) -> Double {
        var celsius: Double

        switch from.symbol {
        case "°C":
            celsius = value
        case "°F":
            celsius = (value - 32) * 5 / 9
        case "K":
            celsius = value - 273.15
        default:
            celsius = value
        }

        switch to.symbol {
        case "°C":
            return celsius
        case "°F":
            return celsius * 9 / 5 + 32
        case "K":
            return celsius + 273.15
        default:
            return celsius
        }
    }
}