//
//  MathExpressionEvaluator.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

class MathExpressionEvaluator {

    enum MathError: Error {
        case invalidExpression
        case divisionByZero
        case invalidFunction
        case syntaxError
    }

    static func evaluate(_ expression: String) -> Result<Double, MathError> {

        let sanitized =
            expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "π", with: String(Double.pi))
            .replacingOccurrences(of: "e", with: String(M_E))

        do {
            let result = try evaluateExpression(sanitized)
            if result.isNaN || result.isInfinite {
                return .failure(.invalidExpression)
            }
            return .success(result)
        } catch {
            if let mathError = error as? MathError {
                return .failure(mathError)
            }
            return .failure(.invalidExpression)
        }
    }

    private static func evaluateExpression(_ expr: String) throws -> Double {
        var expression = expr.trimmingCharacters(in: .whitespaces)

        expression = try processFunctions(expression)
        expression = try processParentheses(expression)

        return try evaluateArithmetic(expression)
    }

    private static func processFunctions(_ expr: String) throws -> String {
        var result = expr

        let functions = ["sin", "cos", "tan", "log", "ln", "sqrt"]

        for function in functions {
            while let range = result.range(
                of: "\(function)\\([^)]+\\)", options: .regularExpression)
            {
                let match = String(result[range])
                guard let argStart = match.firstIndex(of: "("),
                    let argEnd = match.lastIndex(of: ")")
                else {
                    continue
                }

                let arg = String(match[match.index(after: argStart)..<argEnd])

                let argValue = try evaluateExpression(arg)
                let funcResult: Double

                switch function {
                case "sin":
                    funcResult = sin(argValue)
                case "cos":
                    funcResult = cos(argValue)
                case "tan":
                    funcResult = tan(argValue)
                case "log":
                    funcResult = log10(argValue)
                case "ln":
                    funcResult = log(argValue)
                case "sqrt":
                    funcResult = sqrt(argValue)
                default:
                    throw MathError.invalidFunction
                }

                result.replaceSubrange(range, with: String(funcResult))
            }
        }

        return result
    }

    private static func processParentheses(_ expr: String) throws -> String {
        var result = expr

        while let range = result.range(of: "\\([^()]+\\)", options: .regularExpression) {
            let match = String(result[range])
            let inner = String(match.dropFirst().dropLast())
            let innerResult = try evaluateArithmetic(inner)
            result.replaceSubrange(range, with: String(innerResult))
        }

        return result
    }

    private static func evaluateArithmetic(_ expr: String) throws -> Double {
        var expression = expr.trimmingCharacters(in: .whitespaces)

        expression = try processPower(expression)
        expression = try processMultiplicationDivision(expression)
        expression = try processAdditionSubtraction(expression)

        guard let result = Double(expression) else {
            throw MathError.syntaxError
        }

        return result
    }

    private static func processPower(_ expr: String) throws -> String {
        var result = expr

        while let range = result.range(
            of: "-?[0-9.eE+\\-]+\\^-?[0-9.eE+\\-]+", options: .regularExpression)
        {
            let match = String(result[range])
            let parts = match.components(separatedBy: "^")
            guard parts.count == 2,
                let base = Double(parts[0]),
                let exp = Double(parts[1])
            else {
                throw MathError.syntaxError
            }
            let powResult = pow(base, exp)

            if powResult.isNaN || powResult.isInfinite { throw MathError.invalidExpression }
            result.replaceSubrange(range, with: String(powResult))
        }

        return result
    }

    private static func processMultiplicationDivision(_ expr: String) throws -> String {
        var result = expr

        while let range = result.range(
            of: "-?[0-9.eE+\\-]+[*/]-?[0-9.eE+\\-]+", options: .regularExpression)
        {
            let match = String(result[range])

            guard let opIndex = match.lastIndex(where: { $0 == "*" || $0 == "/" }) else {
                throw MathError.syntaxError
            }

            let op = match[opIndex]
            let leftStr = String(match[..<opIndex])
            let rightStr = String(match[match.index(after: opIndex)...])

            guard let left = Double(leftStr),
                let right = Double(rightStr)
            else {
                throw MathError.syntaxError
            }

            let opResult: Double
            if op == "*" {
                opResult = left * right
            } else {
                if right == 0 {
                    throw MathError.divisionByZero
                }
                opResult = left / right
            }

            if opResult.isNaN || opResult.isInfinite { throw MathError.invalidExpression }
            result.replaceSubrange(range, with: String(opResult))
        }

        return result
    }

    private static func processAdditionSubtraction(_ expr: String) throws -> String {
        var result = expr

        while let range = result.range(
            of: "-?[0-9.eE]+\\s*[+\\-]\\s*-?[0-9.eE]+", options: .regularExpression)
        {

            let match = String(result[range])

            var validSplit: (left: Double, right: Double, op: Character)? = nil

            let ops: [Character] = ["+", "-"]
            for i in match.indices.dropFirst() {
                let char = match[i]
                if ops.contains(char) {

                    let prevIndex = match.index(before: i)
                    let prevChar = match[prevIndex]
                    if prevChar == "e" || prevChar == "E" { continue }

                    let lStr = String(match[..<i])
                    let rStr = String(match[match.index(after: i)...])

                    if let l = Double(lStr), let r = Double(rStr) {

                        validSplit = (l, r, char)

                        break
                    }
                }
            }

            guard let split = validSplit else {

                break
            }

            let opResult = split.op == "+" ? split.left + split.right : split.left - split.right

            if opResult.isNaN || opResult.isInfinite { throw MathError.invalidExpression }
            result.replaceSubrange(range, with: String(opResult))
        }

        return result
    }
}