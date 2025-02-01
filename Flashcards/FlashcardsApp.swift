//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 24/01/2025.
//

import SwiftUI

@main
struct FlashcardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
