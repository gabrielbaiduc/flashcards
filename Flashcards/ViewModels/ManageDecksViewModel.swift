import SwiftUI
import SwiftData

@MainActor
class ManageDecksViewModel: ObservableObject {
    private let modelContext: ModelContext
    @Published var name: String = ""
    @Published var selectedFrontLanguage: Language = .english
    @Published var selectedBackLanguage: Language = .english
    @Published var editingDeck: Deck?

    init(context: ModelContext) {
        self.modelContext = context
    }
    
    func loadDeck(_ deck: Deck) {
        name = deck.name
        selectedFrontLanguage = deck.frontLanguage
        selectedBackLanguage = deck.backLanguage
        editingDeck = deck
    }
    
    func saveDeck() {
        if let deck = editingDeck {
            deck.name = name
            deck.frontLanguage = selectedFrontLanguage
            deck.backLanguage = selectedBackLanguage
            editingDeck = nil
        } else {
            let newDeck = Deck(name: name,
                               frontLanguage: selectedFrontLanguage,
                               backLanguage: selectedBackLanguage)
            modelContext.insert(newDeck)
        }
        resetForm()
    }
    
    func deleteDecks(at offsets: IndexSet, from decks: [Deck]) {
        for index in offsets {
            modelContext.delete(decks[index])
        }
    }
    
    func resetForm() {
        name = ""
        selectedFrontLanguage = .english
        selectedBackLanguage = .english
        editingDeck = nil
    }
    
    var isValidForm: Bool {
        !name.isEmpty
    }
}
