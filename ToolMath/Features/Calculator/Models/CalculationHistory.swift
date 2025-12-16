//
//  CalculationHistory.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

struct CalculationHistory: Codable {
    let id: UUID
    let expression: String
    let result: String
    let timestamp: Date

    init(expression: String, result: String) {
        self.id = UUID()
        self.expression = expression
        self.result = result
        self.timestamp = Date()
    }
}