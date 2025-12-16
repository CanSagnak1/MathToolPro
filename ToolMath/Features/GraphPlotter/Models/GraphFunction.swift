//
//  GraphFunction.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation
import UIKit

struct GraphFunction: Identifiable {
    let id: String
    let expression: String
    let color: UIColor
    var visible: Bool

    init(expression: String, color: UIColor, visible: Bool) {
        self.id = UUID().uuidString
        self.expression = expression
        self.color = color
        self.visible = visible
    }
}