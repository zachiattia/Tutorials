//
//  AlefQuestApp.swift
//  AlefQuest Watch App
//
//  App entry point.
//

import SwiftUI

@main
struct AlefQuest_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GameView()
            }
        }
    }
}
