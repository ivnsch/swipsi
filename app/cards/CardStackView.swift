import SwiftUI

struct CardStackView: View {
    @StateObject var viewModel = CardsViewModel(api: Api())
    
    var body: some View {
        ZStack {
            ForEach(viewModel.cardModels) { card in
                CardView(viewModel: viewModel, bike: card)
            }
        }
    }
}

#Preview {
    CardStackView()
}
