//
//  ConversionCategory.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation
import UIKit

enum ConversionCategory: String, CaseIterable {
    case length
    case mass
    case temperature
    case data
    case time
    case speed
    case area
    case volume

    var displayName: String {
        switch self {
        case .length: return "Length"
        case .mass: return "Mass"
        case .temperature: return "Temp"
        case .data: return "Data"
        case .time: return "Time"
        case .speed: return "Speed"
        case .area: return "Area"
        case .volume: return "Volume"
        }
    }

    var icon: String {
        switch self {
        case .length: return "ruler"
        case .mass: return "scalemass"
        case .temperature: return "thermometer"
        case .data: return "externaldrive"
        case .time: return "clock"
        case .speed: return "speedometer"
        case .area: return "square.grid.2x2"
        case .volume: return "cube"
        }
    }

    var units: [Unit] {
        switch self {
        case .length:
            return [
                Unit(name: "Meters", symbol: "m", toBase: 1.0),
                Unit(name: "Kilometers", symbol: "km", toBase: 1000.0),
                Unit(name: "Centimeters", symbol: "cm", toBase: 0.01),
                Unit(name: "Millimeters", symbol: "mm", toBase: 0.001),
                Unit(name: "Miles", symbol: "mi", toBase: 1609.34),
                Unit(name: "Yards", symbol: "yd", toBase: 0.9144),
                Unit(name: "Feet", symbol: "ft", toBase: 0.3048),
                Unit(name: "Inches", symbol: "in", toBase: 0.0254),
            ]
        case .mass:
            return [
                Unit(name: "Kilograms", symbol: "kg", toBase: 1.0),
                Unit(name: "Grams", symbol: "g", toBase: 0.001),
                Unit(name: "Milligrams", symbol: "mg", toBase: 0.000001),
                Unit(name: "Pounds", symbol: "lbs", toBase: 0.453592),
                Unit(name: "Ounces", symbol: "oz", toBase: 0.0283495),
                Unit(name: "Tons", symbol: "t", toBase: 1000.0),
            ]
        case .temperature:
            return [
                Unit(name: "Celsius", symbol: "°C", toBase: 1.0, isTemperature: true),
                Unit(name: "Fahrenheit", symbol: "°F", toBase: 1.0, isTemperature: true),
                Unit(name: "Kelvin", symbol: "K", toBase: 1.0, isTemperature: true),
            ]
        case .data:
            return [
                Unit(name: "Bytes", symbol: "B", toBase: 1.0),
                Unit(name: "Kilobytes", symbol: "KB", toBase: 1024.0),
                Unit(name: "Megabytes", symbol: "MB", toBase: 1048576.0),
                Unit(name: "Gigabytes", symbol: "GB", toBase: 1073741824.0),
                Unit(name: "Terabytes", symbol: "TB", toBase: 1099511627776.0),
            ]
        case .time:
            return [
                Unit(name: "Seconds", symbol: "s", toBase: 1.0),
                Unit(name: "Minutes", symbol: "min", toBase: 60.0),
                Unit(name: "Hours", symbol: "hr", toBase: 3600.0),
                Unit(name: "Days", symbol: "d", toBase: 86400.0),
                Unit(name: "Weeks", symbol: "wk", toBase: 604800.0),
            ]
        case .speed:
            return [
                Unit(name: "M/s", symbol: "m/s", toBase: 1.0),
                Unit(name: "Km/h", symbol: "km/h", toBase: 0.277778),
                Unit(name: "Mph", symbol: "mph", toBase: 0.44704),
                Unit(name: "Knots", symbol: "kn", toBase: 0.514444),
            ]
        case .area:
            return [
                Unit(name: "Sq Meters", symbol: "m²", toBase: 1.0),
                Unit(name: "Sq Kilometers", symbol: "km²", toBase: 1000000.0),
                Unit(name: "Sq Feet", symbol: "ft²", toBase: 0.092903),
                Unit(name: "Acres", symbol: "ac", toBase: 4046.86),
            ]
        case .volume:
            return [
                Unit(name: "Liters", symbol: "L", toBase: 1.0),
                Unit(name: "Milliliters", symbol: "mL", toBase: 0.001),
                Unit(name: "Gallons", symbol: "gal", toBase: 3.78541),
                Unit(name: "Cubic Meters", symbol: "m³", toBase: 1000.0),
            ]
        }
    }
}