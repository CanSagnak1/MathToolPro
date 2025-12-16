//
//  SettingsEnums.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

enum AngleMode: String, Codable, CaseIterable {
    case degrees = "Degrees"
    case radians = "Radians"

    var displayName: String { rawValue }
}

enum AnimationSpeed: String, Codable, CaseIterable {
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"

    var displayName: String { rawValue }
    var duration: TimeInterval {
        switch self {
        case .slow: return 0.5
        case .normal: return 0.3
        case .fast: return 0.15
        }
    }
}

enum LineThickness: String, Codable, CaseIterable {
    case thin = "Thin"
    case medium = "Medium"
    case thick = "Thick"

    var displayName: String { rawValue }
    var width: CGFloat {
        switch self {
        case .thin: return 2.0
        case .medium: return 3.0
        case .thick: return 4.5
        }
    }
}

enum GridDensity: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var displayName: String { rawValue }
    var scale: CGFloat {
        switch self {
        case .low: return 60.0
        case .medium: return 40.0
        case .high: return 25.0
        }
    }
}

enum ConversionCategoryDefault: String, Codable, CaseIterable {
    case length = "Length"
    case mass = "Mass"
    case temperature = "Temperature"
    case volume = "Volume"
    case area = "Area"
    case speed = "Speed"
    case time = "Time"
    case data = "Data"

    var displayName: String { rawValue }
}