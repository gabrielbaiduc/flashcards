import SwiftData
import Foundation


@Model
final class Deck {
    var id: UUID
    var name: String
    
    // New properties for the languages associated with the flashcard sides.
    var frontLanguage: Language
    var backLanguage: Language
    
    // A deck contains many flashcards.
    // The inverse relationship on Flashcard is the `deck` property.
    @Relationship(inverse: \Flashcard.deck)
    var flashcards: [Flashcard] = []
    
    init(name: String,
         frontLanguage: Language,
         backLanguage: Language) {
        self.id = UUID()
        self.name = name
        self.frontLanguage = frontLanguage
        self.backLanguage = backLanguage
    }
}
