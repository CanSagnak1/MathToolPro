//
//  Formula.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import Foundation

enum FormulaCategory: String, CaseIterable, Codable {
    case mathematics = "Mathematics"
    case physics = "Physics"
    case finance = "Finance"
    case geometry = "Geometry"

    var iconName: String {
        switch self {
        case .mathematics: return "function"
        case .physics: return "atom"
        case .finance: return "banknote"
        case .geometry: return "triangle"
        }
    }
}

struct FormulaInput: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let unit: String?
    let defaultValue: Double?
}

struct Formula: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: FormulaCategory
    let inputs: [FormulaInput]
    let evaluate: ([String: Double]) -> Double?
    let resultUnit: String

    // Helper to get variable names
    var variableSymbols: [String] {
        inputs.map { $0.symbol }
    }
}
