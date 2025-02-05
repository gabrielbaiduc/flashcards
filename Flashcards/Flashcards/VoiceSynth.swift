//
//  VoiceSynth.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 02/02/2025.
//

import Foundation
import AVFoundation

/// Supported languages for text-to-speech
enum Voice: String {
    case english = "com.apple.voice.enhanced.en-GB.Stephanie"
    case french = "com.apple.voice.enhanced.fr-FR.Thomas"
}

/// A singleton class that provides text-to-speech functionality using AVSpeechSynthesizer.
/// 
/// Usage example:
/// ```swift
/// VoiceSynth.shared.speak(text: "Hello", language: "english")
/// ```
class VoiceSynth {
    /// The shared instance for accessing the voice synthesizer.
    /// This property ensures only one synthesizer exists in the application.
    static let shared = VoiceSynth()
    /// The underlying AVSpeechSynthesizer instance.
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    // Private initializer to enforce singleton usage.
    // We also ensure that 
    private init() {    
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    /// Speaks the provided text using the specified language and speech rate.
    /// - Parameters:
    ///   - text: The text to be spoken
    ///   - language: The language to use (Voice enum)
    ///   - rate: The speech rate (default is system default rate)
    /// - Note: If speech is already in progress, it will be stopped before the new text is spoken
    func speak(text: String, language: Voice, rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
        if synthesizer.isSpeaking {  // stop any ongoing speech
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(identifier: language.rawValue) {
            utterance.voice = voice
        } else {
            print("Failed to create voice for language: \(language)")
            return
        }
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
    
    /// Stops any ongoing speech immediately.
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
