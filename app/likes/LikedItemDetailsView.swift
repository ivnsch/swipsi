import SwiftUI

struct LikedItemDetailsView: View {
    let item: LikedItem
    
    @State private var currentImageIndex = 0
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: item.pictures[currentImageIndex])) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            // for some reason differently to video it's needed to leave frame here too
                            // otherwise the info view doesn't show
                            .frame(width: UIScreen.main.bounds.width, height: SizeConstants.cardHeight)
//                            .clipped()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
                .background(Color.white)
                .overlay {
                    ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: item.pictures.count)
                }
                if item.pictures.count > 1 {
                    CardImageIndicatorView(currentImageIndex: currentImageIndex, imageCount: item.pictures.count)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: SizeConstants.cardHeight)
            LikedItemDetailsInfoView(item: ItemInfos(name: item.name, price: item.price, priceCurrency: item.priceCurrency, type: item.type, descr: item.descr))
            .navigationTitle(item.name)
            link(item: item)
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.likeBg.ignoresSafeArea())
    }
}

func link(item: LikedItem) -> some View {
    if let url = URL(string: item.vendorLink) {
        return AnyView(
            ZStack {
                Link("Buy on Amazon", destination: url)
                    .buyStyle()
            }
        )
    } else {
        return AnyView(Text("A problem occurred linking to vendor"))
    }
}

extension Link {
    func buyStyle() -> some View {
        fontWeight(.heavy)
        .padding(10)
        .foregroundColor(.blue)
        .background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .stroke(.blue, lineWidth: 2)
            .frame(minWidth: 200, maxWidth: .infinity)
        )
    }
}
