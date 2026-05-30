//
//  ScoreHeader.swift
//  AlefQuest Watch App
//
//  Compact top bar showing the current score and streak.
//

import SwiftUI

struct ScoreHeader: View {
    let score: Int
    let streak: Int
    let streakIcon: String?

    var body: some View {
        HStack {
            Label("\(score)", systemImage: "star.circle.fill")
                .foregroundStyle(.yellow)

            Spacer()

            HStack(spacing: 3) {
                if let icon = streakIcon {
                    Image(systemName: icon)
                        .foregroundStyle(.orange)
                        .transition(.scale.combined(with: .opacity))
                }
                Text("\(streak)")
                    .foregroundStyle(streak > 0 ? .orange : .secondary)
            }
        }
        .font(.system(size: 15, weight: .bold, design: .rounded))
        .monospacedDigit()
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: streak)
    }
}
