import SwiftUI

struct CardStackView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var viewModel = CardsViewModel(api: Api())
    

    var body: some View {
        ZStack {
            ForEach(viewModel.cardModels) { card in
                CardView(viewModel: viewModel, bike: card)
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    CardStackView()
}
