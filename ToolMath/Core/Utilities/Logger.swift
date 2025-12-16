//
//  Logger.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 16.12.2025.
//

import Foundation

class Logger {
    static let shared = Logger()

    private init() {}

    func log(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "📝 [LOG] \(fileName):\(line) - \(function) -> \(message)"
        print(logMessage)
    }

    func error(
        _ message: String, file: String = #file, function: String = #function, line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "❌ [ERROR] \(fileName):\(line) - \(function) -> \(message)"
        print(logMessage)
    }
}