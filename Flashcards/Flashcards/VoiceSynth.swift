//
//  VoiceSynth.swift
//  Flashcards
//
//  Created by Gabriel Baiduc on 02/02/2025.
//

import Foundation
import AVFoundation

/// A singleton class that provides text-to-speech functionality using AVSpeechSynthesizer.
class VoiceSynth {
    
    private let french: String = "com.apple.voice.enhanced.fr-FR.Thomas"
    private let english: String = "com.apple.voice.enhanced.en-GB.Stephanie"
    
    /// Shared instance for accessing the voice synthesizer.
    static let shared = VoiceSynth()
    
    /// The underlying AVSpeechSynthesizer instance.
    private let synthesizer = AVSpeechSynthesizer()
    
    /// Private initializer to enforce singleton usage.
    private init() { }
    
    /// Speaks the provided text using the specified language and speech rate.
    /// - Parameters:
    ///   - text: The text to be spoken.
    ///   - language: The language code for the voice (default is "en-US"). Use appropriate language codes for your learning content.
    ///   - rate: The speech rate. Use `AVSpeechUtteranceDefaultSpeechRate` for the default rate or adjust as needed.
    func speak(text: String, language: String, rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
        // If the synthesizer is already speaking, stop it before starting a new utterance.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Create an utterance with the given text.
        let utterance = AVSpeechUtterance(string: text)
        // Configure the voice using the provided language code.
        if (language == "french") {
            utterance.voice = AVSpeechSynthesisVoice(identifier: french)
        } else {
            utterance.voice = AVSpeechSynthesisVoice(identifier: english)
        }
        // Set the desired speech rate.
        utterance.rate = rate
        
        // Start speaking the utterance.
        synthesizer.speak(utterance)
    }
    
    /// Stops any ongoing speech immediately.
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
