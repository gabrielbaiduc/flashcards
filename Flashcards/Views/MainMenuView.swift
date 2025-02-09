//
//  MainMenuView.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 05/02/2025.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {
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
                
                NavigationLink(destination: ManageDeckView()) {
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

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            // For Core Data-like testing with SwiftData,
            // wrap with modelContainer if required.
            .modelContainer(for: Flashcard.self, inMemory: true)
    }
}
