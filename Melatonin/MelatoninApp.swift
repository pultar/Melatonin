//
//  MelatoninApp.swift
//  Melatonin
//

import SwiftUI
import SwiftData

@main
struct MelatoninApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Computer.self)
    }
}
