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

            VStack(spacing: 2) {
                if let hint = viewModel.currentQuestion?.hint {
                    Text(hint)
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                Text(viewModel.currentQuestion?.hebrew ?? "")
                    .font(.system(size: promptFontSize, weight: .bold))
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .foregroundStyle(.white)
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
    private var promptFontSize: CGFloat {
        switch viewModel.level {
        case .letters: return 70
        case .order:   return 60   // single letter, but leaves room for the hint
        case .sounds:  return 60
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
