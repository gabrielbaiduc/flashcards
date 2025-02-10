import SwiftUI
import SwiftData

struct ManageDecksView: View {
    let modelContext: ModelContext
    @Query private var decks: [Deck]
    @StateObject private var viewModel: ManageDecksViewModel
    @State private var isPresentingDeckSheet = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _viewModel = StateObject(wrappedValue: ManageDecksViewModel(context: modelContext))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(decks) { deck in
                    NavigationLink(destination: ManageDeckView(deck: deck, modelContext: modelContext)) {
                        DeckRow(deck: deck)
                    }
                }
                .onDelete { offsets in
                    withAnimation {
                        viewModel.deleteDecks(at: offsets, from: decks)
                    }
                }
            }
            .navigationTitle("Manage Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.resetForm()
                        isPresentingDeckSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isPresentingDeckSheet) {
                DeckFormView(viewModel: viewModel, isPresented: $isPresentingDeckSheet)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
}

struct DeckRow: View {
    let deck: Deck
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(deck.name)
                .font(.headline)
            HStack {
                Text("Front: \(deck.frontLanguage.rawValue)")
                    .font(.subheadline)
                Text("Back: \(deck.backLanguage.rawValue)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}