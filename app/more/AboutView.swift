//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Swipsi is an app to browse products from third party stores in an original and fun way.\n\nDeveloper:\nIvan Schütz\nUST xxxxxxxx\nBirkenstrasse 15\n10559, Berlin\nGermany").padding(20)
                    .foregroundColor(Color.black)
            }
            
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("About")
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
