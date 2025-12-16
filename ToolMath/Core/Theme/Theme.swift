//
//  Theme.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

struct Theme {
    
    struct Colors {
        static let primary = UIColor(hex: "#0dccf2")
        static let background = UIColor(hex: "#101f22")
        static let surface = UIColor(hex: "#16282b")
        static let surfaceSecondary = UIColor(hex: "#182b2e")
        static let surfaceCard = UIColor(hex: "#16282b")
        static let secondaryText = UIColor.systemGray
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor.lightGray
        static let error = UIColor.systemRed
        static let success = UIColor.systemGreen
    }
    
    struct Fonts {
        static func display(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
            let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded)!
            return UIFont(descriptor: descriptor, size: size)
        }
        
        static func mono(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
            return UIFont.monospacedSystemFont(ofSize: size, weight: weight)
        }
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    struct Animation {
        static let fast: TimeInterval = 0.15
        static let normal: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5
        static let spring: TimeInterval = 0.6
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let button: CGFloat = 14
        static let card: CGFloat = 20
    }
}