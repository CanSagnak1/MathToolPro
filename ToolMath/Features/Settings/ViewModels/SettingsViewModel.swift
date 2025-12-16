//
//  SettingsViewModel.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import Foundation

class SettingsViewModel {
    private var settings = AppSettings.load()
    private var cancellables = Set<AnyCancellable>()

    @Published var hapticFeedbackEnabled: Bool
    @Published var animationSpeed: AnimationSpeed

    @Published var angleMode: AngleMode
    @Published var decimalPlaces: Int
    @Published var scientificNotationEnabled: Bool
    @Published var thousandsSeparatorEnabled: Bool

    @Published var defaultZoomLevel: Double
    @Published var graphLineThickness: LineThickness
    @Published var graphGridDensity: GridDensity
    @Published var graphShowAxes: Bool
    @Published var graphAntialiasing: Bool

    @Published var converterDefaultCategory: ConversionCategoryDefault
    @Published var converterAutoConvert: Bool
    @Published var converterHistorySize: Int

    @Published var developerMode: Bool
    @Published var performanceMode: Bool

    let hapticFeedbackEnabledChange = PassthroughSubject<Bool, Never>()
    let animationSpeedChange = PassthroughSubject<AnimationSpeed, Never>()
    let angleModeChange = PassthroughSubject<AngleMode, Never>()
    let decimalPlacesChange = PassthroughSubject<Int, Never>()
    let scientificNotationChange = PassthroughSubject<Bool, Never>()
    let thousandsSeparatorChange = PassthroughSubject<Bool, Never>()
    let defaultZoomChange = PassthroughSubject<Double, Never>()
    let lineThicknessChange = PassthroughSubject<LineThickness, Never>()
    let gridDensityChange = PassthroughSubject<GridDensity, Never>()
    let showAxesChange = PassthroughSubject<Bool, Never>()
    let antialiasingChange = PassthroughSubject<Bool, Never>()
    let defaultCategoryChange = PassthroughSubject<ConversionCategoryDefault, Never>()
    let autoConvertChange = PassthroughSubject<Bool, Never>()
    let historySizeChange = PassthroughSubject<Int, Never>()
    let developerModeChange = PassthroughSubject<Bool, Never>()
    let performanceModeChange = PassthroughSubject<Bool, Never>()

    let clearCalculatorHistoryTrigger = PassthroughSubject<Void, Never>()
    let clearConverterHistoryTrigger = PassthroughSubject<Void, Never>()
    let clearAllDataTrigger = PassthroughSubject<Void, Never>()
    let resetSettingsTrigger = PassthroughSubject<Void, Never>()

    init() {

        self.hapticFeedbackEnabled = settings.hapticFeedbackEnabled
        self.animationSpeed = settings.animationSpeed
        self.angleMode = settings.angleMode
        self.decimalPlaces = settings.decimalPlaces
        self.scientificNotationEnabled = settings.scientificNotationEnabled
        self.thousandsSeparatorEnabled = settings.thousandsSeparatorEnabled
        self.defaultZoomLevel = Double(settings.defaultZoomLevel)
        self.graphLineThickness = settings.graphLineThickness
        self.graphGridDensity = settings.graphGridDensity
        self.graphShowAxes = settings.showAxesLabels
        self.graphAntialiasing = settings.graphAntialiasing
        self.converterDefaultCategory = settings.defaultConversionCategory
        self.converterAutoConvert = settings.autoConvert
        self.converterHistorySize = 20
        self.developerMode = settings.developerMode
        self.performanceMode = settings.performanceMode

        setupBindings()
    }

    private func setupBindings() {

        hapticFeedbackEnabledChange.sink { [weak self] value in
            self?.hapticFeedbackEnabled = value
            self?.settings.hapticFeedbackEnabled = value
            self?.settings.save()
        }.store(in: &cancellables)

        animationSpeedChange.sink { [weak self] value in
            self?.animationSpeed = value
            self?.settings.animationSpeed = value
            self?.settings.save()
        }.store(in: &cancellables)

        clearCalculatorHistoryTrigger.sink {
            UserDefaults.standard.removeObject(forKey: "calculator_history")
        }.store(in: &cancellables)

        clearConverterHistoryTrigger.sink {
            UserDefaults.standard.removeObject(forKey: "converter_history")
        }.store(in: &cancellables)

        clearAllDataTrigger.sink { [weak self] in
            self?.clearAllData()
        }.store(in: &cancellables)

        resetSettingsTrigger.sink { [weak self] in
            self?.resetSettings()
        }.store(in: &cancellables)
    }

    private func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "calculator_history")
        UserDefaults.standard.removeObject(forKey: "converter_history")
    }

    private func resetSettings() {
        settings.resetToDefaults()

        hapticFeedbackEnabled = settings.hapticFeedbackEnabled
        animationSpeed = settings.animationSpeed
        angleMode = settings.angleMode
        decimalPlaces = settings.decimalPlaces
        scientificNotationEnabled = settings.scientificNotationEnabled
        thousandsSeparatorEnabled = settings.thousandsSeparatorEnabled
        defaultZoomLevel = Double(settings.defaultZoomLevel)
        graphLineThickness = settings.graphLineThickness
        graphGridDensity = settings.graphGridDensity
        graphShowAxes = settings.showAxesLabels
        graphAntialiasing = settings.graphAntialiasing
        converterDefaultCategory = settings.defaultConversionCategory
        converterAutoConvert = settings.autoConvert
        converterHistorySize = 20
        developerMode = settings.developerMode
        performanceMode = settings.performanceMode
    }
}