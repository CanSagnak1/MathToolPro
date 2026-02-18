//
//  MathNote.swift
//  ToolMath
//
//  Created by Celal Can Sağnak on 18.02.2026.
//

import Foundation

struct MathNote: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var lastModified: Date

    init(
        id: UUID = UUID(), title: String, content: String, createdAt: Date = Date(),
        lastModified: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.lastModified = lastModified
    }
}
