//
//  DictionaryEntry.swift
//  ChineseReader
//
//  Model for dictionary entries from CC-CEDICT
//

import Foundation

struct DictionaryEntry: Identifiable, Codable {
    var id: String { traditional + simplified }
    
    let traditional: String
    let simplified: String
    let pinyin: String
    let definitions: [String]
    
    init(traditional: String, simplified: String, pinyin: String, definitions: [String]) {
        self.traditional = traditional
        self.simplified = simplified
        self.pinyin = pinyin
        self.definitions = definitions
    }
    
    /// Parse a CC-CEDICT line format:
    /// 傳統 传统 [chuan2 tong3] /tradition/traditional/
    static func parse(from line: String) -> DictionaryEntry? {
        // Skip comments and empty lines
        guard !line.isEmpty, !line.hasPrefix("#") else { return nil }
        
        // Split by square brackets for pinyin
        let components = line.components(separatedBy: "[")
        guard components.count >= 2 else { return nil }
        
        // Extract traditional and simplified
        let words = components[0].trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        guard words.count >= 2 else { return nil }
        
        let traditional = words[0]
        let simplified = words[1]
        
        // Extract pinyin and definitions
        let rest = components[1].components(separatedBy: "]")
        guard rest.count >= 2 else { return nil }
        
        let pinyin = rest[0].trimmingCharacters(in: .whitespaces)
        
        // Parse definitions (separated by /)
        let definitionString = rest[1].trimmingCharacters(in: .whitespaces)
        let definitions = definitionString
            .components(separatedBy: "/")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        guard !definitions.isEmpty else { return nil }
        
        return DictionaryEntry(
            traditional: traditional,
            simplified: simplified,
            pinyin: pinyin,
            definitions: definitions
        )
    }
}

