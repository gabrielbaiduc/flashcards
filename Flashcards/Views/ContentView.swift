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
    @Query private var flashcards: [Flashcard]
    
    @State private var currentCard: Flashcard?
    @State private var isFlipped = false
    @State private var guess = ""
    @State private var rotationAngle = 0.0
    @State private var showCard = true
    @State private var currentLang: String = "english"
    
    @FocusState private var isGuessFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            if let card = currentCard {
                // Card view with top padding and fade animation.
                VStack {
                    ZStack {
                        // Front side
                        Text(card.frontText)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                            .scaleEffect(rotationAngle > 90 ? 0 : 1) // Hide when rotated past 90°

                        // Back side
                        Text(card.backText)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                            .scaleEffect(rotationAngle > 90 ? 1 : 0) // Show only when flipped
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                    .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let textToSpeak = isFlipped ? card.backText : card.frontText
                        VoiceSynth.shared.speak(text: textToSpeak, language: currentLang)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20) // spacing from top
                .opacity(showCard ? 1 : 0)
                
                // Input area below the card.
                if isFlipped {
                    Button("Next Card") {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            showCard = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            loadRandomCard()
                            withAnimation(.easeInOut(duration: 0.1)) {
                                showCard = true
                            }
                        }
                    }
                } else {
                    TextField("Your guess", text: $guess)
                        .focused($isGuessFocused)
                        .multilineTextAlignment(.center)
                        .cornerRadius(8)
                        .onTapGesture { isGuessFocused = true }
                        .onSubmit {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                rotationAngle += 180
                                isFlipped.toggle()
                            }
                        }
                }
            } else {
                Text("No flashcards available")
            }
            Spacer() // push content to the top
        }
        .padding()
        // Prevent the keyboard from pushing the view upward.
        .onAppear(perform: loadRandomCard)
        .onChange(of: isFlipped) {
            currentLang = isFlipped ? "french" : "english"
        }
    }
    
    private func loadRandomCard() {
        guard let card = flashcards.randomElement() else {
            currentCard = nil
            return
        }
        currentCard = card
        isFlipped = false
        guess = ""
        rotationAngle = 0
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
