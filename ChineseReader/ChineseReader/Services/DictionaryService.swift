//
//  DictionaryService.swift
//  ChineseReader
//
//  Protocol for dictionary lookup using CC-CEDICT
//

import Foundation

protocol DictionaryServiceProtocol {
    func lookup(word: String) async throws -> [DictionaryEntry]
    func loadDictionary() async throws
}

final class DictionaryService: DictionaryServiceProtocol {
    private var dictionary: [String: [DictionaryEntry]] = [:]
    private var isLoaded = false
    
    enum DictionaryError: LocalizedError {
        case notLoaded
        case wordNotFound
        case dictionaryFileNotFound
        
        var errorDescription: String? {
            switch self {
            case .notLoaded:
                return "Dictionary not loaded. Call loadDictionary() first."
            case .wordNotFound:
                return "Word not found in dictionary"
            case .dictionaryFileNotFound:
                return "Dictionary file not found in bundle"
            }
        }
    }
    
    func lookup(word: String) async throws -> [DictionaryEntry] {
        guard isLoaded else {
            throw DictionaryError.notLoaded
        }
        
        // Try to find exact match first
        if let entries = dictionary[word] {
            return entries
        }
        
        // Try to find entries that start with the word (for compound words)
        let matchingEntries = dictionary.values
            .flatMap { $0 }
            .filter { $0.simplified.hasPrefix(word) || $0.traditional.hasPrefix(word) }
        
        guard !matchingEntries.isEmpty else {
            throw DictionaryError.wordNotFound
        }
        
        return matchingEntries
    }
    
    func loadDictionary() async throws {
        guard !isLoaded else { return }
        
        // In production, this would load from a bundled CC-CEDICT file
        // For now, we'll use a placeholder that loads from a resource file
        guard let url = Bundle.main.url(forResource: "cedict_ts", withExtension: "u8") else {
            throw DictionaryError.dictionaryFileNotFound
        }
        
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            guard let entry = DictionaryEntry.parse(from: line) else { continue }
            
            // Index by both simplified and traditional
            dictionary[entry.simplified, default: []].append(entry)
            if entry.traditional != entry.simplified {
                dictionary[entry.traditional, default: []].append(entry)
            }
        }
        
        isLoaded = true
    }
}

