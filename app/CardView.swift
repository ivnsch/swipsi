import SwiftUI

struct CardView: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(.bike)
                .resizable()
                .scaledToFill()
                // for some reason differently to video it's needed to leave frame here too
                // otherwise the info view doesn't show
                .frame(width: cardWidth, height: cardHeight)
            BikeInfoView()
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
}

private extension CardView {
    var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 20
    }
    
    var cardHeight: CGFloat {
        UIScreen.main.bounds.height / 1.45
    }
}

#Preview {
    CardView()
}
