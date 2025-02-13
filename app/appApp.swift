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
            LikedItem.self,
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
                        Label("Browse", systemImage: "sparkle.magnifyingglass")
                    }
                LikedItemsView()
                    .tabItem {
                        Label("Favs", systemImage: "star")
                    }
                PreferencesOutlineView()
                    .tabItem {
                        Label("Filters", systemImage: "switch.2")
                    }
                ContentView()
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
