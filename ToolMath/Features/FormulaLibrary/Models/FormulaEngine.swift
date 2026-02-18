//
//  FormulaEngine.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import Foundation

class FormulaEngine {

    static let shared = FormulaEngine()

    private init() {}

    // Predetermined list of formulas
    lazy var allFormulas: [Formula] = [
        // MARK: - Geometry
        Formula(
            title: "Area of Circle",
            description: "Calculate the area of a circle given its radius.",
            category: .geometry,
            inputs: [
                FormulaInput(name: "Radius", symbol: "r", unit: "m", defaultValue: nil)
            ],
            evaluate: { inputs in
                guard let r = inputs["r"] else { return nil }
                return Double.pi * pow(r, 2)
            },
            resultUnit: "m²"
        ),
        Formula(
            title: "Volume of Sphere",
            description: "Calculate the volume of a sphere given its radius.",
            category: .geometry,
            inputs: [
                FormulaInput(name: "Radius", symbol: "r", unit: "m", defaultValue: nil)
            ],
            evaluate: { inputs in
                guard let r = inputs["r"] else { return nil }
                return (4.0 / 3.0) * Double.pi * pow(r, 3)
            },
            resultUnit: "m³"
        ),
        Formula(
            title: "Pythagorean Theorem",
            description: "Calculate the hypotenuse of a right triangle.",
            category: .geometry,
            inputs: [
                FormulaInput(name: "Side A", symbol: "a", unit: "m", defaultValue: nil),
                FormulaInput(name: "Side B", symbol: "b", unit: "m", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let a = inputs["a"], let b = inputs["b"] else { return nil }
                return sqrt(pow(a, 2) + pow(b, 2))
            },
            resultUnit: "m"
        ),

        // MARK: - Physics
        Formula(
            title: "Newton's Second Law",
            description: "Calculate force given mass and acceleration.",
            category: .physics,
            inputs: [
                FormulaInput(name: "Mass", symbol: "m", unit: "kg", defaultValue: nil),
                FormulaInput(name: "Acceleration", symbol: "a", unit: "m/s²", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let m = inputs["m"], let a = inputs["a"] else { return nil }
                return m * a
            },
            resultUnit: "N"
        ),
        Formula(
            title: "Kinetic Energy",
            description: "Calculate the kinetic energy of an object.",
            category: .physics,
            inputs: [
                FormulaInput(name: "Mass", symbol: "m", unit: "kg", defaultValue: nil),
                FormulaInput(name: "Velocity", symbol: "v", unit: "m/s", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let m = inputs["m"], let v = inputs["v"] else { return nil }
                return 0.5 * m * pow(v, 2)
            },
            resultUnit: "J"
        ),
        Formula(
            title: "Ohm's Law (Voltage)",
            description: "Calculate voltage given current and resistance.",
            category: .physics,
            inputs: [
                FormulaInput(name: "Current", symbol: "I", unit: "A", defaultValue: nil),
                FormulaInput(name: "Resistance", symbol: "R", unit: "Ω", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let I = inputs["I"], let R = inputs["R"] else { return nil }
                return I * R
            },
            resultUnit: "V"
        ),

        // MARK: - Finance
        Formula(
            title: "Simple Interest",
            description: "Calculate simple interest earned.",
            category: .finance,
            inputs: [
                FormulaInput(name: "Principal", symbol: "P", unit: "$", defaultValue: nil),
                FormulaInput(name: "Rate", symbol: "r", unit: "%", defaultValue: nil),
                FormulaInput(name: "Time", symbol: "t", unit: "years", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let P = inputs["P"], let r = inputs["r"], let t = inputs["t"] else {
                    return nil
                }
                return P * (r / 100.0) * t
            },
            resultUnit: "$"
        ),
        Formula(
            title: "Compound Interest (Annual)",
            description: "Calculate compound interest for annual compounding.",
            category: .finance,
            inputs: [
                FormulaInput(name: "Principal", symbol: "P", unit: "$", defaultValue: nil),
                FormulaInput(name: "Rate", symbol: "r", unit: "%", defaultValue: nil),
                FormulaInput(name: "Time", symbol: "t", unit: "years", defaultValue: nil),
            ],
            evaluate: { inputs in
                guard let P = inputs["P"], let r = inputs["r"], let t = inputs["t"] else {
                    return nil
                }
                // A = P(1 + r/n)^(nt) where n=1
                return P * pow((1 + r / 100.0), t)
            },
            resultUnit: "$"
        ),
        Formula(
            title: "VAT Calculation",
            description: "Calculate VAT amount given net price and rate.",
            category: .finance,
            inputs: [
                FormulaInput(name: "Net Price", symbol: "P", unit: "$", defaultValue: nil),
                FormulaInput(name: "VAT Rate", symbol: "r", unit: "%", defaultValue: 18),  // Default 18
            ],
            evaluate: { inputs in
                guard let P = inputs["P"], let r = inputs["r"] else { return nil }
                return P * (r / 100.0)
            },
            resultUnit: "$"
        ),
    ]

    func getFormulas(for category: FormulaCategory) -> [Formula] {
        return allFormulas.filter { $0.category == category }
    }

    func searchFormulas(query: String) -> [Formula] {
        return searchFormulas(query: query, in: allFormulas)
    }

    func searchFormulas(query: String, in source: [Formula]) -> [Formula] {
        guard !query.isEmpty else { return source }
        return source.filter {
            $0.title.localizedCaseInsensitiveContains(query)
                || $0.description.localizedCaseInsensitiveContains(query)
        }
    }
}
