//
//  Book.swift
//  ChineseReader
//
//  Model for organizing captured texts into books/collections
//

import Foundation
import SwiftData

@Model
final class Book: Identifiable {
    var id: UUID
    var title: String
    var author: String?
    var coverImageData: Data?
    var createdAt: Date
    var updatedAt: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \CapturedText.book)
    var pages: [CapturedText]?
    
    init(
        id: UUID = UUID(),
        title: String,
        author: String? = nil,
        coverImageData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.coverImageData = coverImageData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.pages = []
    }
    
    var pageCount: Int {
        pages?.count ?? 0
    }
    
    var totalCharacterCount: Int {
        pages?.reduce(0) { $0 + $1.content.count } ?? 0
    }
}

