//
//  GraphViewModel.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Combine
import Foundation
import UIKit

@MainActor
class GraphViewModel {

    private var cancellables = Set<AnyCancellable>()

    let addFunctionTrigger = PassthroughSubject<String, Never>()
    let removeFunctionTrigger = PassthroughSubject<String, Never>()
    let toggleFunctionTrigger = PassthroughSubject<String, Never>()
    let scaleChange = PassthroughSubject<CGFloat, Never>()

    @Published var functions: [GraphFunction] = []
    @Published var scale: CGFloat = 40.0

    var availableColors: [UIColor] = [
        Theme.Colors.primary,
        .systemPink,
        .systemGreen,
        .systemOrange,
        .systemPurple,
        .systemYellow,
        .systemTeal,
    ]

    init() {
        functions = []

        let settings = AppSettings.load()
        scale = CGFloat(settings.defaultZoomLevel)
        setupBindings()
    }

    private func setupBindings() {
        addFunctionTrigger
            .sink { [weak self] expression in
                guard let self = self else { return }
                Logger.shared.log("Adding function request: \(expression)")
                let colorIndex = self.functions.count % self.availableColors.count
                let newFunc = GraphFunction(
                    expression: expression,
                    color: self.availableColors[colorIndex],
                    visible: true
                )
                self.functions.append(newFunc)
                Logger.shared.log("Function added. Total functions: \(self.functions.count)")
            }
            .store(in: &cancellables)

        removeFunctionTrigger
            .sink { [weak self] id in
                self?.functions.removeAll { $0.id == id }
            }
            .store(in: &cancellables)

        toggleFunctionTrigger
            .sink { [weak self] id in
                guard let self = self,
                    let index = self.functions.firstIndex(where: { $0.id == id })
                else { return }
                self.functions[index].visible.toggle()
            }
            .store(in: &cancellables)

        scaleChange
            .assign(to: &$scale)
    }

    func evaluatedPoints(
        for function: GraphFunction, width: CGFloat, height: CGFloat, scale: CGFloat
    ) -> [CGPoint] {
        Logger.shared.log(
            "Evaluating points for: \(function.expression), width: \(width), height: \(height)")
        guard function.visible, width > 0, height > 0, scale > 0 else {
            Logger.shared.log("Skipping evaluation: valid condition failed")
            return []
        }

        var points: [CGPoint] = []
        let center = CGPoint(x: width / 2, y: height / 2)

        let minX = -width / 2 / scale
        let maxX = width / 2 / scale

        let step = max((maxX - minX) / 500.0, 0.001)

        for xValue in stride(from: minX, through: maxX, by: step) {
            if let y = ExpressionParser.evaluate(expression: function.expression, x: xValue) {
                if !y.isNaN && !y.isInfinite {
                    let screenX = center.x + (xValue * scale)
                    let screenY = center.y - (y * scale)

                    if screenY >= -height * 2 && screenY <= height * 3 {
                        points.append(CGPoint(x: screenX, y: screenY))
                    }
                }
            }
        }

        return points
    }
}