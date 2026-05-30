//
//  ScoreHeader.swift
//  AlefQuest Watch App
//
//  Prominent top bar showing the two metrics the game is built around:
//  current SCORE and current STREAK.
//

import SwiftUI

struct ScoreHeader: View {
    let score: Int
    let streak: Int
    let streakIcon: String?

    var body: some View {
        HStack(spacing: 8) {
            metric(
                value: score,
                caption: "SCORE",
                systemImage: "star.circle.fill",
                tint: .yellow,
                accessory: nil
            )

            metric(
                value: streak,
                caption: "STREAK",
                systemImage: "bolt.fill",
                tint: streak > 0 ? .orange : .secondary,
                accessory: streakIcon
            )
        }
        .monospacedDigit()
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: streak)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: score)
    }

    /// A single boxed metric: a big number with a small caption underneath.
    private func metric(value: Int, caption: String, systemImage: String,
                        tint: Color, accessory: String?) -> some View {
        VStack(spacing: 1) {
            HStack(spacing: 3) {
                Image(systemName: systemImage)
                    .font(.system(size: 14))
                Text("\(value)")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .contentTransition(.numericText())
                if let accessory {
                    Image(systemName: accessory)
                        .font(.system(size: 14))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            Text(caption)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .tracking(1)
        }
        .foregroundStyle(tint)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .background(tint.opacity(0.15), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 12) {
        ScoreHeader(score: 7, streak: 0, streakIcon: nil)
        ScoreHeader(score: 23, streak: 6, streakIcon: "flame.fill")
        ScoreHeader(score: 41, streak: 21, streakIcon: "trophy.fill")
    }
    .padding()
}
