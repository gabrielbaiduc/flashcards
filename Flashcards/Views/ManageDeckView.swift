//
//  ManageDeckView.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 05/02/2025.
//

import SwiftUI
import SwiftData

struct ManageDeckView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var flashcards: [Flashcard]

    @StateObject private var viewModel = ManageDeckViewModel()
    @State private var isPresentingFlashcardSheet = false
    
    var body: some View {
        List {
            ForEach(flashcards) { flashcard in
                FlashcardButton(flashcard: flashcard) {
                    viewModel.loadFlashcard(flashcard)
                    isPresentingFlashcardSheet = true
                }
            }
            .onDelete { offsets in
                withAnimation {
                    viewModel.deleteFlashcards(at: offsets, from: flashcards)
                }
            }
        }
        .navigationTitle("Manage Deck")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.resetForm()
                    isPresentingFlashcardSheet = true
                }) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $isPresentingFlashcardSheet) {
            FlashcardFormView(viewModel: viewModel, isPresented: $isPresentingFlashcardSheet)
        }
    }
}

// Separate form view
struct FlashcardFormView: View {
    @ObservedObject var viewModel: ManageDeckViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                FlashcardFormSection(title: "Front Side", 
                                   text: $viewModel.frontText, 
                                   alt: $viewModel.frontAlt)
                
                FlashcardFormSection(title: "Back Side", 
                                   text: $viewModel.backText, 
                                   alt: $viewModel.backAlt)
                
                Section(header: Text("Additional Information")) {
                    TextField("Part of Speech", text: $viewModel.pos)
                }
            }
            .navigationTitle(viewModel.editingFlashcard == nil ? "New Flashcard" : "Edit Flashcard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                        viewModel.resetForm()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.editingFlashcard == nil ? "Save" : "Update") {
                        viewModel.saveFlashcard()
                        isPresented = false
                    }
                    .disabled(!viewModel.isValidForm)
                }
            }
        }
    }
}

// Reusable components
struct FlashcardFormSection: View {
    let title: String
    @Binding var text: String
    @Binding var alt: String
    
    var body: some View {
        Section(header: Text(title)) {
            TextField("Primary Text", text: $text)
            TextField("Alternative Form (Optional)", text: $alt)
        }
    }
}

struct FlashcardButton: View {
    let flashcard: Flashcard
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            FlashcardRow(flashcard: flashcard)
                .foregroundColor(.black)
        }
        .listRowInsets(EdgeInsets())
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.clear)
        .contentShape(Rectangle())
        
    }
}

// Separate view for the flashcard row to improve readability
struct FlashcardRow: View {
    let flashcard: Flashcard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(flashcard.frontText)
                        .font(.headline)
                    if let alt = flashcard.frontAlt {
                        Text(alt)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(flashcard.backText)
                        .font(.headline)
                    if let alt = flashcard.backAlt {
                        Text(alt)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            if let pos = flashcard.pos {
                Text(pos)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
