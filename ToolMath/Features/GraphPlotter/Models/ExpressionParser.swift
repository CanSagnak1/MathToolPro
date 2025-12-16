//
//  ExpressionParser.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

class ExpressionParser {

    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.locale = Locale(identifier: "en_US")
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = 10
        fmt.usesGroupingSeparator = false
        return fmt
    }()

    static func evaluate(expression: String, x: Double) -> Double? {

        guard let formattedX = formatter.string(from: NSNumber(value: x)) else { return nil }

        var expr =
            expression
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "π", with: String(Double.pi))
            .replacingOccurrences(of: "e", with: String(M_E))

        expr = expr.replacingOccurrences(of: "x", with: "(\(formattedX))")

        guard let result = try? MathExpressionEvaluator.evaluate(expr).get() else {
            return nil
        }

        return result
    }
}