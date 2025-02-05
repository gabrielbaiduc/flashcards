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
    @StateObject private var viewModel = LearnViewModel()
    
    @FocusState private var isGuessFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            if let card = viewModel.currentCard {
                FlashcardView(
                    card: card,
                    rotationAngle: viewModel.rotationAngle,
                    isFlipped: viewModel.isFlipped,
                    onTap: {
                        let textToSpeak = viewModel.isFlipped ? card.backText : card.frontText
                        VoiceSynth.shared.speak(text: textToSpeak, language: viewModel.currentVoice)
                    }
                )
                .padding(.horizontal)
                .padding(.top, 20)
                .opacity(viewModel.showCard ? 1 : 0)
                
                if viewModel.isFlipped {
                    Button("Next Card") {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.showCard = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.loadRandomCard(from: flashcards)
                            withAnimation(.easeInOut(duration: 0.1)) {
                                viewModel.showCard = true
                            }
                        }
                    }
                } else {
                    TextField("Your guess", text: $viewModel.guess)
                        .focused($isGuessFocused)
                        .multilineTextAlignment(.center)
                        .cornerRadius(8)
                        .onTapGesture { isGuessFocused = true }
                        .onSubmit {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.flipCard()
                            }
                        }
                }
            } else {
                Text("No flashcards available")
            }
            Spacer() // Push content to the top.
        }
        .padding()
        .onAppear {
            viewModel.loadRandomCard(from: flashcards)
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
            .modelContainer(for: Flashcard.self, inMemory: true)
    }
}
