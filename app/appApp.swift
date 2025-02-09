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
            LikedBike.self,
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
                        Label("Select", systemImage: "sparkle.magnifyingglass")
                    }
                LikedBikesView()
                    .tabItem {
                        Label("Favs", systemImage: "star")
                    }
                BikePreferencesView()
                    .tabItem {
                        Label("Preferences", systemImage: "switch.2")
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
