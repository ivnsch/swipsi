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
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: bike.pictures[currentImageIndex])) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            // for some reason differently to video it's needed to leave frame here too
                            // otherwise the info view doesn't show
                            .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                            .clipped()
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
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
