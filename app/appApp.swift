//
//  appApp.swift
//  app
//
//  Created by Ivan Schuetz on 06.02.25.
//

import SwiftUI
import SwiftData

@main
struct appApp: App {
    var api = Api()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Match", systemImage: "tray.and.arrow.down.fill")
                    }
                ContentView()
                    .tabItem {
                        Label("Likes", systemImage: "tray.and.arrow.up.fill")
                    }
                ContentView()
                    .tabItem {
                        Label("Preferences", systemImage: "tray.and.arrow.up.fill")
                    }
                ContentView()
                    .tabItem {
                        Label("More", systemImage: "tray.and.arrow.up.fill")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
