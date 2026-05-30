//
//  HebrewQuestion.swift
//  AlefQuest Watch App
//
//  The core data model for a single question in the game.
//

import Foundation

/// A difficulty level in the game. Higher raw values are harder.
enum GameLevel: Int, CaseIterable, Identifiable, Comparable {
    case letters = 1    // Single Hebrew letters:   א → Alef
    case sounds = 2     // Vowelled syllables:      בָ → Ba
    case words = 3      // Whole words:             שָׁלוֹם → Shalom
    case phrases = 4    // Short phrases:           שָׁלוֹם אַבָּא → Shalom Abba

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .letters: return "Letters"
        case .sounds:  return "Sounds"
        case .words:   return "Words"
        case .phrases: return "Phrases"
        }
    }

    /// Emoji used as a friendly label for the level.
    var emoji: String {
        switch self {
        case .letters: return "🔤"
        case .sounds:  return "🔊"
        case .words:   return "📖"
        case .phrases: return "💬"
        }
    }

    static func < (lhs: GameLevel, rhs: GameLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// A single multiple-choice question.
struct HebrewQuestion: Identifiable, Equatable {
    let id = UUID()

    /// The Hebrew text shown to the player (letter, syllable, word, or phrase).
    let hebrew: String

    /// The correct English transliteration.
    let answer: String

    /// All answer choices shown to the player. Includes `answer`.
    let options: [String]

    /// The difficulty level this question belongs to.
    let level: GameLevel

    static func == (lhs: HebrewQuestion, rhs: HebrewQuestion) -> Bool {
        lhs.id == rhs.id
    }
}
