//
//  TextSegmentationService.swift
//  ChineseReader
//
//  Protocol for segmenting Chinese text into words using NLTokenizer
//

import Foundation
import NaturalLanguage

protocol TextSegmentationServiceProtocol {
    func segmentText(_ text: String, language: String) -> [WordToken]
}

struct WordToken: Identifiable {
    let id = UUID()
    let text: String
    let range: Range<String.Index>
    var isWhitespace: Bool { text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}

final class TextSegmentationService: TextSegmentationServiceProtocol {
    
    func segmentText(_ text: String, language: String = "zh-Hans") -> [WordToken] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        // Set language for better segmentation
        if language.starts(with: "zh") {
            tokenizer.setLanguage(.simplifiedChinese)
        }
        
        var tokens: [WordToken] = []
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let word = String(text[range])
            tokens.append(WordToken(text: word, range: range))
            return true
        }
        
        return tokens
    }
    
    /// Extract sentences from text for context display
    func segmentSentences(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        var sentences: [String] = []
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range])
            sentences.append(sentence.trimmingCharacters(in: .whitespacesAndNewlines))
            return true
        }
        
        return sentences
    }
}

