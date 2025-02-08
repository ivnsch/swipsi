//
//  LikedBikeDetailsView.swift
//  app
//
//  Created by Ivan Schuetz on 08.02.25.
//

import SwiftUI

struct LikedBikeDetailsView: View {
    let bike: LikedBike
    
    @State private var currentImageIndex = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top) {
                    AsyncImage(url: URL(string: bike.pictures[currentImageIndex])) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
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
                    .overlay {
                        ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: bike.pictures.count)
                    }
                    CardImageIndicatorView(currentImageIndex: currentImageIndex, imageCount: bike.pictures.count)
                    
                }
    //            BikeInfoView(bike: bike)
            }
            .navigationTitle(bike.name)
            .frame(width: UIScreen.main.bounds.width, height: SizeConstants.cardHeight)
        }
        link(bike: bike)
    }
}

func link(bike: LikedBike) -> some View {
    if let url = URL(string: bike.vendorLink) {
        return AnyView(Link("Go to vendor", destination: url))
    } else {
        return AnyView(Text("A problem occurred linking to vendor"))
    }
}
