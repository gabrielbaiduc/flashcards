import SwiftUI
import SwiftData
import Observation

@MainActor
class ManageDeckViewModel: ObservableObject {
    var modelContext: ModelContext!
    @Published var frontText = ""
    @Published var backText = ""
    @Published var frontAlt = ""
    @Published var backAlt = ""
    @Published var pos = ""
    @Published var editingFlashcard: Flashcard?

    init() { }
    
    func loadFlashcard(_ flashcard: Flashcard) {
        frontText = flashcard.frontText
        backText = flashcard.backText
        frontAlt = flashcard.frontAlt ?? ""
        backAlt = flashcard.backAlt ?? ""
        pos = flashcard.pos ?? ""
        editingFlashcard = flashcard
    }
    
    func saveFlashcard() {
        if let flashcard = editingFlashcard {
            updateFlashcard(flashcard)
        } else {
            addFlashcard()
        }
        resetForm()
    }
    
    private func updateFlashcard(_ flashcard: Flashcard) {
        flashcard.frontText = frontText
        flashcard.backText = backText
        flashcard.frontAlt = frontAlt.isEmpty ? nil : frontAlt
        flashcard.backAlt = backAlt.isEmpty ? nil : backAlt
        flashcard.pos = pos.isEmpty ? nil : pos
        editingFlashcard = nil
    }
    
    private func addFlashcard() {
        let newFlashcard = Flashcard(
            frontText: frontText,
            backText: backText,
            frontAlt: frontAlt.isEmpty ? nil : frontAlt,
            backAlt: backAlt.isEmpty ? nil : backAlt,
            pos: pos.isEmpty ? nil : pos
        )
        modelContext.insert(newFlashcard)
    }
    
    func deleteFlashcards(at offsets: IndexSet, from flashcards: [Flashcard]) {
        for index in offsets {
            modelContext.delete(flashcards[index])
        }
    }
    
    func resetForm() {
        frontText = ""
        backText = ""
        frontAlt = ""
        backAlt = ""
        pos = ""
        editingFlashcard = nil
    }
    
    var isValidForm: Bool {
        !frontText.isEmpty && !backText.isEmpty
    }
}
