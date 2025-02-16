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
        CardStackView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Browse")
                        .foregroundColor(.black)
                }
            }

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
    }
}

#imageLiteral(resourceName: "simulator_screenshot_76FC43AD-58CD-4896-B10D-C882F1083C4C.png")
