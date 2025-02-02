//
//  ContentView.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 01/02/2025.
//

import SwiftUI
import SwiftData

// MARK: - Main View

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink(destination: LearnView()) {
                    Text("Learn")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                }
                
                NavigationLink(destination: ManageView()) {
                    Text("Manage")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                }
            }
            .padding()
            .navigationTitle("Flashcards")
        }
    }
}

// MARK: - Learn View

struct LearnView: View {
    var body: some View {
        Text("Learn View – To be implemented")
            .font(.headline)
            .padding()
            .navigationTitle("Learn")
    }
}

// MARK: - Manage View

struct ManageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var flashcards: [Flashcard]
    
    // State to manage the add flashcard sheet and input text fields.
    @State private var isPresentingAddFlashcardSheet = false
    @State private var newFrontText = ""
    @State private var newBackText = ""
    
    var body: some View {
        List {
            ForEach(flashcards) { flashcard in
                HStack {
                    Text(flashcard.frontText)
                    Spacer()
                    Text(flashcard.backText)
                }
            }
            .onDelete(perform: deleteFlashcards)
        }
        .navigationTitle("Manage Deck")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Show the sheet when the add button is tapped.
                Button(action: {
                    isPresentingAddFlashcardSheet = true
                }) {
                    Label("Add Flashcard", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        // Present a sheet with text fields for user input.
        .sheet(isPresented: $isPresentingAddFlashcardSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Front Text")) {
                        TextField("Enter front text", text: $newFrontText)
                    }
                    Section(header: Text("Back Text")) {
                        TextField("Enter back text", text: $newBackText)
                    }
                }
                .navigationTitle("New Flashcard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            // Reset the input and dismiss the sheet.
                            newFrontText = ""
                            newBackText = ""
                            isPresentingAddFlashcardSheet = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            addFlashcard()
                            isPresentingAddFlashcardSheet = false
                        }
                    }
                }
            }
        }
    }
    
    private func addFlashcard() {
        withAnimation {
            let newFlashcard = Flashcard(frontText: newFrontText, backText: newBackText)
            modelContext.insert(newFlashcard)
            // Clear the input values.
            newFrontText = ""
            newBackText = ""
        }
    }
    
    private func deleteFlashcards(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(flashcards[index])
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MainView()
        .modelContainer(for: Flashcard.self, inMemory: true)
}
