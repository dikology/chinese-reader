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
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}
