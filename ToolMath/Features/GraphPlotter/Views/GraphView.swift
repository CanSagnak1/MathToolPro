//
//  GraphView.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import UIKit

class GraphView: UIView {

    var functions: [GraphFunction] = [] {
        didSet { setNeedsDisplay() }
    }

    var scale: CGFloat = 40.0 {
        didSet { setNeedsDisplay() }
    }

    weak var viewModel: GraphViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#0b1618")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        Logger.shared.log("Draw called. Rect: \(rect)")
        guard let ctx = UIGraphicsGetCurrentContext() else {
            Logger.shared.error("Could not get graphics context")
            return
        }

        let settings = AppSettings.load()

        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2

        let gridScale = settings.graphGridDensity.scale

        ctx.setLineWidth(1)
        ctx.setStrokeColor(UIColor(white: 1, alpha: 0.1).cgColor)

        var x = centerX
        while x < width {
            ctx.move(to: CGPoint(x: x, y: 0))
            ctx.addLine(to: CGPoint(x: x, y: height))
            x += gridScale
        }
        x = centerX
        while x > 0 {
            ctx.move(to: CGPoint(x: x, y: 0))
            ctx.addLine(to: CGPoint(x: x, y: height))
            x -= gridScale
        }

        var y = centerY
        while y < height {
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: width, y: y))
            y += gridScale
        }
        y = centerY
        while y > 0 {
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: width, y: y))
            y -= gridScale
        }
        ctx.strokePath()

        ctx.setLineWidth(2)
        ctx.setStrokeColor(UIColor.gray.withAlphaComponent(0.5).cgColor)

        ctx.move(to: CGPoint(x: centerX, y: 0))
        ctx.addLine(to: CGPoint(x: centerX, y: height))

        ctx.move(to: CGPoint(x: 0, y: centerY))
        ctx.addLine(to: CGPoint(x: width, y: centerY))

        ctx.strokePath()

        guard let vm = viewModel else { return }

        for funcItem in functions where funcItem.visible {
            let points = vm.evaluatedPoints(
                for: funcItem, width: width, height: height, scale: scale)
            guard points.count > 1 else { continue }

            let path = UIBezierPath()
            path.move(to: points[0])
            for pt in points.dropFirst() {
                path.addLine(to: pt)
            }

            funcItem.color.setStroke()

            path.lineWidth = settings.graphLineThickness.width

            if settings.graphAntialiasing {
                ctx.setShouldAntialias(true)
            }

            path.stroke()

            if funcItem.color == Theme.Colors.primary {
                ctx.saveGState()
                ctx.setShadow(offset: .zero, blur: 10, color: funcItem.color.cgColor)
                path.stroke()
                ctx.restoreGState()
            }
        }

        Theme.Colors.primary.setFill()
        let dot = UIBezierPath(
            ovalIn: CGRect(x: centerX - 6, y: centerY - 6, width: 12, height: 12))
        dot.fill()
    }
}