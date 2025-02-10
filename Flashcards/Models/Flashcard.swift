//
//  Item.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 01/02/2025.
//

import Foundation
import SwiftData

enum Language: String, Codable, CaseIterable {
    case english = "English"
    case french = "French"
    // Add additional languages as needed
}

@Model
final class Flashcard {
    var id: UUID
    var frontText: String
    var backText: String

    var frontAlt: String?
    var backAlt: String?

    var pos: String?
    var lastReviewed: Date?
    var score: Double = 1.0
    
    var deck: Deck
    
    init(frontText: String, 
         backText: String, 
         frontAlt: String? = nil,
         backAlt: String? = nil,
         gender: String? = nil,
         pos: String? = nil,
         deck: Deck) {
        self.id = UUID()
        self.frontText = frontText
        self.backText = backText
        self.frontAlt = frontAlt
        self.backAlt = backAlt
        self.pos = pos
        self.deck = deck
    }
}
