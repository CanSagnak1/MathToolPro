//
//  ConversionHistory.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

struct ConversionHistory: Codable {
    let id: UUID
    let fromValue: String
    let fromUnit: String
    let toValue: String
    let toUnit: String
    let category: String
    let timestamp: Date

    init(fromValue: String, fromUnit: String, toValue: String, toUnit: String, category: String) {
        self.id = UUID()
        self.fromValue = fromValue
        self.fromUnit = fromUnit
        self.toValue = toValue
        self.toUnit = toUnit
        self.category = category
        self.timestamp = Date()
    }
}