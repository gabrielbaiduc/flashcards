//
//  Item.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 01/02/2025.
//

import Foundation
import SwiftData

@Model
final class Flashcard {
    var id: UUID
    var frontText: String
    var backText: String
    var difficulty: Int
    var timestamp: Date
    
    init(frontText: String, backText: String, difficulty: Int = 1) {
        self.id = UUID()
        self.frontText = frontText
        self.backText = backText
        self.difficulty = difficulty
        self.timestamp = Date()
    }
}
