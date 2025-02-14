//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct FeedbackView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Do you have feature requests, questions or complaints? Join the discord!")
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.black)
                    Button(action: {
                         guard let url = URL(string: "https://discord.gg/Pwx7Sh8Suf"),
                             UIApplication.shared.canOpenURL(url) else {
                             return
                         }
                         UIApplication.shared.open(url,
                                                   options: [:],
                                                   completionHandler: nil)
                     }) {
                         Image(.discord)
                            .resizable()
                            .frame(width: 70, height: 53)
                            .buttonStyle(PlainButtonStyle())
                            .tint(Color.black)
                        }
                     .tint(Color.black)
                }
            }

#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("Feedback")
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Feedback")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
