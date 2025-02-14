import SwiftUI
import SwiftData

struct MoreView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Text("About")
                    }
                    NavigationLink {
                        FeedbackView()
                    } label: {
                        Text("Feedback")
                    }
                    NavigationLink {
                        LegalView()
                    } label: {
                        Text("Legal")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                  Text("More")
                        .foregroundColor(.black)
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
