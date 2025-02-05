//
//  LearnView.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 05/02/2025.
//

import SwiftUI
import SwiftData

struct LearnView: View {
    @Query private var flashcards: [Flashcard]
    
    @State private var currentCard: Flashcard?
    @State private var isFlipped = false
    @State private var guess = ""
    @State private var rotationAngle = 0.0
    @State private var showCard = true
    @State private var currentLang: Voice = .english
    
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
        .onChange(of: isFlipped) { newValue in
            currentLang = newValue ? .french : .english
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

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
            // For Core Data-like testing with SwiftData,
            // wrap with modelContainer if required.
            .modelContainer(for: Flashcard.self, inMemory: true)
    }
}