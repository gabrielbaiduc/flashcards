//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 01/02/2025.
//

import SwiftUI
import SwiftData

@main
struct FlashcardsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Flashcard.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
            LearnView()
            ManageView()
        }
        .modelContainer(sharedModelContainer)
    }
}
