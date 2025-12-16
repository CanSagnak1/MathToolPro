//
//  AppSettings.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

struct AppSettings: Codable {

    var theme: String
    var hapticFeedbackEnabled: Bool
    var animationSpeed: AnimationSpeed

    var angleMode: AngleMode
    var scientificNotationEnabled: Bool
    var decimalPlaces: Int
    var thousandsSeparatorEnabled: Bool
    var autoEvaluate: Bool

    var graphLineThickness: LineThickness
    var graphGridDensity: GridDensity
    var showAxesLabels: Bool
    var graphAntialiasing: Bool
    var defaultZoomLevel: Float

    var defaultConversionCategory: ConversionCategoryDefault
    var autoConvert: Bool
    var roundConverterResults: Bool

    var developerMode: Bool
    var performanceMode: Bool

    static let `default` = AppSettings(

        theme: "dark",
        hapticFeedbackEnabled: true,
        animationSpeed: .normal,

        angleMode: .degrees,
        scientificNotationEnabled: true,
        decimalPlaces: 4,
        thousandsSeparatorEnabled: false,
        autoEvaluate: false,

        graphLineThickness: .medium,
        graphGridDensity: .medium,
        showAxesLabels: true,
        graphAntialiasing: true,
        defaultZoomLevel: 40.0,

        defaultConversionCategory: .length,
        autoConvert: true,
        roundConverterResults: true,

        developerMode: false,
        performanceMode: false
    )

    private static let userDefaultsKey = "app_settings_v2"

    static func load() -> AppSettings {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
            let settings = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return .default
        }
        return settings
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: AppSettings.userDefaultsKey)
        }
    }

    mutating func resetToDefaults() {
        self = .default
        save()
    }

    func exportToJSON() -> String? {
        guard let data = try? JSONEncoder().encode(self),
            let jsonString = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return jsonString
    }

    static func importFromJSON(_ jsonString: String) -> AppSettings? {
        guard let data = jsonString.data(using: .utf8),
            let settings = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return nil
        }
        return settings
    }
}