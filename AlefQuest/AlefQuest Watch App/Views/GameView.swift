//
//  GameView.swift
//  AlefQuest Watch App
//
//  The main gameplay screen: score header, large Hebrew prompt, and the
//  multiple-choice answer buttons.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showingLevelPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ScoreHeader(
                    score: viewModel.score,
                    streak: viewModel.streak,
                    streakIcon: viewModel.streakIcon
                )

                hebrewPrompt

                answerButtons
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .navigationTitle(viewModel.level.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingLevelPicker = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $showingLevelPicker) {
            LevelPickerView(
                selected: viewModel.level,
                bestStreak: viewModel.bestStreak,
                totalScore: viewModel.totalScore
            ) { newLevel in
                viewModel.changeLevel(to: newLevel)
                showingLevelPicker = false
            }
        }
    }

    // MARK: - Hebrew prompt

    private var hebrewPrompt: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(promptBackground)

            VStack(spacing: 4) {
                if let hint = viewModel.currentQuestion?.hint {
                    Text(hint)
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }

                if viewModel.currentQuestion?.level == .order {
                    orderSequence
                } else {
                    Text(viewModel.currentQuestion?.hebrew ?? "")
                        .font(.system(size: promptFontSize, weight: .bold))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 90)
        .overlay(alignment: .bottom) {
            feedbackBanner
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.feedback)
    }

    /// Font size for the big Hebrew prompt, tuned per level.
    /// (The Letter Order level renders its own sequence cells instead.)
    private var promptFontSize: CGFloat {
        switch viewModel.level {
        case .letters: return 70
        case .order:   return 44
        case .sounds:  return 60
        }
    }

    /// The three-slot sequence for the Letter Order level. Rendered
    /// right-to-left (proper Hebrew direction): the earliest letter is on the
    /// right, so the alef-bet reads naturally.
    private var orderSequence: some View {
        let tokens = (viewModel.currentQuestion?.hebrew ?? "")
            .split(separator: Character(QuestionBank.sequenceSeparator))
            .map(String.init)

        return HStack(spacing: 6) {
            ForEach(Array(tokens.enumerated()), id: \.offset) { _, token in
                sequenceCell(token)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    @ViewBuilder
    private func sequenceCell(_ token: String) -> some View {
        let isBlank = (token == QuestionBank.blankToken)
        Text(isBlank ? "" : token)
            .font(.system(size: 34, weight: .bold))
            .frame(width: 42, height: 54)
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isBlank ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
            }
            .overlay {
                if isBlank {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.white.opacity(0.9),
                                      style: StrokeStyle(lineWidth: 2, dash: [4]))
                }
            }
    }

    private var promptBackground: Color {
        switch viewModel.feedback {
        case .none:    return Color.indigo.opacity(0.55)
        case .correct: return Color.green.opacity(0.55)
        case .wrong:   return Color.red.opacity(0.45)
        }
    }

    @ViewBuilder
    private var feedbackBanner: some View {
        switch viewModel.feedback {
        case .correct:
            Text(viewModel.isMilestoneStreak ? "🔥 \(viewModel.streak) streak!" : "Correct!")
                .font(.caption2.bold())
                .padding(.vertical, 2).padding(.horizontal, 8)
                .background(.green, in: Capsule())
                .padding(.bottom, 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        case .wrong(let correct):
            Text("→ \(correct)")
                .font(.caption2.bold())
                .padding(.vertical, 2).padding(.horizontal, 8)
                .background(.red, in: Capsule())
                .padding(.bottom, 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        case .none:
            EmptyView()
        }
    }

    // MARK: - Answers

    private var answerButtons: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.currentQuestion?.options ?? [], id: \.self) { option in
                AnswerButton(
                    title: option,
                    feedback: viewModel.feedback,
                    isSelected: viewModel.selectedOption == option,
                    isCorrectAnswer: option == viewModel.currentQuestion?.answer
                ) {
                    viewModel.checkAnswer(option)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
