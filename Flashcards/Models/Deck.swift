import SwiftData

@Model
final class Deck {
    var name: String

    // A deck contains many flashcards.
    // The inverse relationship on Flashcard is the `deck` property.
    @Relationship(inverse: \Flashcard.deck)
    var flashcards: [Flashcard] = []
    
    init(name: String) {
        self.name = name
    }
}