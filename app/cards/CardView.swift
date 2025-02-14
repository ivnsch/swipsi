import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardsViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    @State private var showingDetails: Bool = false
    
    let item: Item
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                if !item.pictures.isEmpty {
                    AsyncImage(url: URL(string: item.pictures[currentImageIndex])) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                // for some reason differently to video it's needed to leave frame here too
                                // otherwise the info view doesn't show
                                .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                                .background(.white)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                    .overlay {
                        ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
                    }
                   
                }
                if item.pictures.count > 1 {
                    CardImageIndicatorView(currentImageIndex: currentImageIndex, imageCount: imageCount)
                }
                SwipeActionIndicatorView(xOffset: $xOffset)
                
            }
            HStack {
                Spacer()
                Button {
                    showingDetails = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .tint(Theme.cardInfo)
                .frame(width: 60, height: 60)
            }
        }
        // doesn't work for some reason..
//        .onTapGesture(perform: {
//            print("tap!")
//            showingDetails = true
//        })
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
        .sheet(isPresented: $showingDetails) {
            DetailsPopup(item: item)
                .presentationDetents([.large])
        }
 
    }
}

private struct DetailsPopup: View {
    let item: Item
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                Text(item.price)
            }
        }
        link(item: item)
    }
}

func link(item: Item) -> some View {
    if let url = URL(string: item.vendorLink) {
        return AnyView(Link("Go to vendor", destination: url))
    } else {
        return AnyView(Text("A problem occurred linking to vendor"))
    }
}


private extension CardView {
    var imageCount: Int {
        return item.pictures.count
    }
}
private extension CardView {
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.like(item)
        }
    }
    
    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.dislike(item)
        }
    }
}

private extension CardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width;
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnToCenter()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}

private extension CardView {

}

