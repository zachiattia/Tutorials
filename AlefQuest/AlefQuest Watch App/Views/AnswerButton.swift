//
//  AnswerButton.swift
//  AlefQuest Watch App
//
//  A large, easy-to-tap multiple-choice button that recolors to show whether
//  the chosen answer was correct or wrong.
//

import SwiftUI

struct AnswerButton: View {
    let title: String
    let feedback: AnswerFeedback
    let isSelected: Bool
    let isCorrectAnswer: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, minHeight: 40)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(background)
        .foregroundStyle(foreground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(alignment: .trailing) {
            if let symbol = trailingSymbol {
                Image(systemName: symbol)
                    .font(.headline)
                    .padding(.trailing, 12)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: feedback)
    }

    // MARK: - Styling driven by feedback

    private var showResult: Bool {
        feedback != .none
    }

    private var background: Color {
        guard showResult else { return Color.white.opacity(0.12) }
        if isCorrectAnswer { return .green }
        if isSelected      { return .red }
        return Color.white.opacity(0.12)
    }

    private var foreground: Color {
        guard showResult else { return .white }
        if isCorrectAnswer || isSelected { return .white }
        return .white.opacity(0.5)
    }

    private var trailingSymbol: String? {
        guard showResult else { return nil }
        if isCorrectAnswer { return "checkmark.circle.fill" }
        if isSelected      { return "xmark.circle.fill" }
        return nil
    }
}
