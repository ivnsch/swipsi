//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct LegalView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                    .padding(20)
                    .foregroundColor(Color.black)

            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Legal")
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("About")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
