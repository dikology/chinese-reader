//
//  CapturedText.swift
//  ChineseReader
//
//  Core model for text captured via OCR or imported from external sources
//

import Foundation
import SwiftData

@Model
final class CapturedText: Identifiable {
    var id: UUID
    var content: String
    var source: TextSource
    var createdAt: Date
    var title: String
    
    // Optional metadata
    var sourceURL: String?
    var language: String // "zh-Hans" or "zh-Hant"
    
    // Relationships
    var book: Book?
    
    init(
        id: UUID = UUID(),
        content: String,
        source: TextSource,
        title: String = "",
        sourceURL: String? = nil,
        language: String = "zh-Hans",
        book: Book? = nil
    ) {
        self.id = id
        self.content = content
        self.source = source
        self.title = title.isEmpty ? "Untitled" : title
        self.sourceURL = sourceURL
        self.language = language
        self.createdAt = Date()
        self.book = book
    }
}

enum TextSource: String, Codable {
    case camera = "camera"
    case manual = "manual"
    case imported = "imported"
}

