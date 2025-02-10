import SwiftUI
import SwiftData

struct DeckFormView: View {
    @ObservedObject var viewModel: ManageDecksViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Details")) {
                    TextField("Deck Name", text: $viewModel.name)
                }
                
                Section(header: Text("Languages")) {
                    Picker("Front Language", selection: $viewModel.selectedFrontLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                    Picker("Back Language", selection: $viewModel.selectedBackLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.editingDeck == nil ? "New Deck" : "Edit Deck")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                        viewModel.resetForm()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.editingDeck == nil ? "Save" : "Update") {
                        viewModel.saveDeck()
                        isPresented = false
                    }
                    .disabled(!viewModel.isValidForm)
                }
            }
        }
    }
}