import SwiftUI

/// A view that displays a flashcard with flip animation.
struct FlashcardView: View {
    let card: Flashcard
    let rotationAngle: Double
    let isFlipped: Bool
    let onTap: () -> Void

    var body: some View {
        ZStack {
            // Front side
            Text(card.frontText)
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                .scaleEffect(rotationAngle > 90 ? 0 : 1)

            // Back side
            Text(card.backText)
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                .scaleEffect(rotationAngle > 90 ? 1 : 0)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
