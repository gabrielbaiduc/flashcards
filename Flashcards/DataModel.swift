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
    var forwardScore: Float
    var backText: String
    var backwardScore: Float
    var pos: String?
    var timestamp: Date
    
    init(frontText: String, backText: String, pos: String? = nil) {
        self.id = UUID()
        self.frontText = frontText
        self.forwardScore = 0.0
        self.backText = backText
        self.backwardScore = 0.0
        self.pos = pos
        self.timestamp = Date()
    }
}
