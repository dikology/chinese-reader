//
//  OCRService.swift
//  ChineseReader
//
//  Protocol for text recognition from images using Vision framework
//

import Foundation
import UIKit
import Vision

protocol OCRServiceProtocol {
    func recognizeText(from image: UIImage, language: String) async throws -> String
}

final class OCRService: OCRServiceProtocol {
    
    enum OCRError: LocalizedError {
        case invalidImage
        case noTextFound
        case recognitionFailed(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "Invalid image provided"
            case .noTextFound:
                return "No text found in image"
            case .recognitionFailed(let message):
                return "Recognition failed: \(message)"
            }
        }
    }
    
    func recognizeText(from image: UIImage, language: String = "zh-Hans") async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.invalidImage
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                if recognizedText.isEmpty {
                    continuation.resume(throwing: OCRError.noTextFound)
                } else {
                    continuation.resume(returning: recognizedText)
                }
            }
            
            // Configure for Chinese text recognition
            request.recognitionLanguages = [language]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error.localizedDescription))
            }
        }
    }
}

