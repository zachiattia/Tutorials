//
//  HebrewQuestion.swift
//  AlefQuest Watch App
//
//  The core data model for a single question in the game.
//

import Foundation

/// A difficulty level in the game. Higher raw values are harder.
/// Declaration order is the order shown in the level picker.
enum GameLevel: Int, CaseIterable, Identifiable, Comparable {
    case letters = 1    // Single Hebrew letters:   א → Alef
    case order = 2      // Alef-bet sequence:       א → (next?) Bet
    case sounds = 3     // Vowelled syllables:      בָ → Ba

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .letters: return "Letters"
        case .order:   return "Letter Order"
        case .sounds:  return "Sounds"
        }
    }

    /// Emoji used as a friendly label for the level.
    var emoji: String {
        switch self {
        case .letters: return "🔤"
        case .order:   return "🔢"
        case .sounds:  return "🔊"
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

    /// Optional instruction shown above the Hebrew text. Used by the
    /// Letter Order level ("What comes NEXT?" / "What comes BEFORE?").
    var hint: String? = nil

    static func == (lhs: HebrewQuestion, rhs: HebrewQuestion) -> Bool {
        lhs.id == rhs.id
    }
}
