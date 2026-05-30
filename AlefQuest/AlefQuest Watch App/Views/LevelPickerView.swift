//
//  LevelPickerView.swift
//  AlefQuest Watch App
//
//  A sheet for switching difficulty levels and seeing overall progress.
//

import SwiftUI

struct LevelPickerView: View {
    let selected: GameLevel
    let bestStreak: Int
    let totalScore: Int
    let onSelect: (GameLevel) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Choose a Level")
                    .font(.headline)
                    .padding(.top, 4)

                ForEach(GameLevel.allCases) { level in
                    Button {
                        onSelect(level)
                    } label: {
                        HStack {
                            Text(level.emoji)
                            Text(level.title)
                                .fontWeight(.semibold)
                            Spacer()
                            if level == selected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(level == selected ? .indigo : .gray)
                }

                progressFooter
            }
            .padding(.horizontal, 6)
        }
    }

    private var progressFooter: some View {
        VStack(spacing: 4) {
            Divider().padding(.vertical, 4)
            Label("Best streak: \(bestStreak)", systemImage: "flame.fill")
                .foregroundStyle(.orange)
            Label("Total points: \(totalScore)", systemImage: "star.fill")
                .foregroundStyle(.yellow)
        }
        .font(.caption2)
        .padding(.top, 4)
    }
}

#Preview {
    LevelPickerView(selected: .letters, bestStreak: 12, totalScore: 134) { _ in }
}
