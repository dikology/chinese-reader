//
//  ChineseReaderApp.swift
//  ChineseReader
//
//  Created by Денис on 11/7/25.
//

import SwiftUI
import SwiftData

@main
struct ChineseReaderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CapturedText.self,
            Book.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // In production, attempt to recover or use in-memory fallback
            print("⚠️ Failed to create persistent ModelContainer: \(error)")
            print("📝 Falling back to in-memory storage")
            
            // Fallback to in-memory storage
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                // This should never happen with in-memory storage, but if it does,
                // we have no choice but to crash
                fatalError("Failed to create even in-memory ModelContainer: \(error)")
            }
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}
