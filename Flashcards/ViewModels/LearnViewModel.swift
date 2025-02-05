import Foundation

/// View model for the Learn view.
final class LearnViewModel: ObservableObject {
    @Published var currentCard: Flashcard?
    @Published var isFlipped: Bool = false
    @Published var guess: String = ""
    @Published var rotationAngle: Double = 0.0
    @Published var showCard: Bool = true

    /// Determines which voice language should be used.
    var currentVoice: Voice {
        return isFlipped ? .french : .english
    }
    
    /// Loads a random flashcard from the given collection.
    /// - Parameter flashcards: The list of flashcards available.
    func loadRandomCard(from flashcards: [Flashcard]) {
        guard let card = flashcards.randomElement() else {
            currentCard = nil
            return
        }
        currentCard = card
        isFlipped = false
        guess = ""
        rotationAngle = 0
    }
    
    /// Flips the card by updating the rotation and flipped state.
    func flipCard() {
        rotationAngle += 180
        isFlipped.toggle()
    }
}
