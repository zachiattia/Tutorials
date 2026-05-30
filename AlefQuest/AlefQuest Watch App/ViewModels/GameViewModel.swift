//
//  GameViewModel.swift
//  AlefQuest Watch App
//
//  Holds all game state and logic: the current question, score, streaks,
//  answer feedback, and progress persistence.
//

import SwiftUI
import WatchKit

/// Feedback state after the player taps an answer.
enum AnswerFeedback: Equatable {
    case none
    case correct
    case wrong(correctAnswer: String)
}

@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var level: GameLevel
    @Published private(set) var currentQuestion: HebrewQuestion?
    @Published private(set) var score = 0
    @Published private(set) var streak = 0
    @Published private(set) var bestStreak = 0
    @Published private(set) var feedback: AnswerFeedback = .none

    /// The option the player tapped, used to highlight their choice.
    @Published private(set) var selectedOption: String?

    /// True while feedback is showing and taps should be ignored.
    @Published private(set) var isLocked = false

    // MARK: - Private state

    private var queue: [HebrewQuestion] = []

    // Streak milestones that unlock celebratory rewards.
    static let flameStreak = 5
    static let starStreak = 10
    static let unlockStreak = 20

    // Persisted progress keys.
    private let bestStreakKey = "alefquest.bestStreak"
    private let totalScoreKey = "alefquest.totalScore"

    /// Cumulative score across all sessions (for a simple progress sense).
    @Published private(set) var totalScore = 0

    // MARK: - Init

    init(level: GameLevel = .letters) {
        self.level = level
        self.bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
        self.totalScore = UserDefaults.standard.integer(forKey: totalScoreKey)
        startNewRound()
    }

    // MARK: - Round / level management

    /// Reloads the queue for the current level and presents the first question.
    func startNewRound() {
        queue = QuestionBank.shuffledQuestions(for: level)
        score = 0
        streak = 0
        feedback = .none
        selectedOption = nil
        isLocked = false
        currentQuestion = queue.popLast()
    }

    func changeLevel(to newLevel: GameLevel) {
        guard newLevel != level else { return }
        level = newLevel
        startNewRound()
    }

    // MARK: - Answering

    func checkAnswer(_ option: String) {
        guard !isLocked, let question = currentQuestion else { return }

        isLocked = true
        selectedOption = option

        if option == question.answer {
            handleCorrect()
        } else {
            handleWrong(correctAnswer: question.answer)
        }

        // Brief pause so the player can see the feedback, then advance.
        let delay: TimeInterval = (feedback == .correct) ? 0.7 : 1.4
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.advance()
        }
    }

    private func handleCorrect() {
        score += 1
        totalScore += 1
        streak += 1
        feedback = .correct

        if streak > bestStreak {
            bestStreak = streak
            UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        }
        UserDefaults.standard.set(totalScore, forKey: totalScoreKey)

        // Haptics: a sharper notification on milestones, otherwise a light tick.
        if isMilestoneStreak {
            WKInterfaceDevice.current().play(.success)
        } else {
            WKInterfaceDevice.current().play(.click)
        }
    }

    private func handleWrong(correctAnswer: String) {
        // Encouraging, non-punishing: we never drop below zero.
        score = max(0, score - 1)
        streak = 0
        feedback = .wrong(correctAnswer: correctAnswer)
        WKInterfaceDevice.current().play(.retry)
    }

    private func advance() {
        feedback = .none
        selectedOption = nil
        isLocked = false

        if queue.isEmpty {
            // Loop endlessly so a session never abruptly ends — just reshuffle.
            queue = QuestionBank.shuffledQuestions(for: level)
        }
        currentQuestion = queue.popLast()
    }

    // MARK: - Streak helpers

    var isMilestoneStreak: Bool {
        streak == Self.flameStreak
            || streak == Self.starStreak
            || streak >= Self.unlockStreak
    }

    /// The reward icon to display for the current streak, if any.
    var streakIcon: String? {
        switch streak {
        case Self.unlockStreak...: return "trophy.fill"
        case Self.starStreak...:   return "star.fill"
        case Self.flameStreak...:  return "flame.fill"
        default:                   return nil
        }
    }
}
