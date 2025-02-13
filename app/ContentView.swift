//
//  ContentView.swift
//  app
//
//  Created by Ivan Schuetz on 06.02.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var api: Api

    var body: some View {
        NavigationSplitView {
            
            CardStackView()
                .navigationTitle("Browse")

#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.mainBg.ignoresSafeArea())
        } detail: {
            Text("Select an item")
        }
    }
}

