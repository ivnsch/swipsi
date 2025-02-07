//
//  CardImageIndicatorView.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import SwiftUI

struct CardImageIndicatorView: View {
    var currentImageIndex: Int
    let imageCount: Int
    
    var body: some View {
        HStack {
            
            ForEach(0..<imageCount, id: \.self) { index in
                Capsule()
                    .foregroundStyle(currentImageIndex == index ? .red : .gray)
                    .frame(width: imageIndicatorWidth, height: 4)
                    .padding(.top, 8)
            }
        }
    }
}

private extension CardImageIndicatorView {
    var imageIndicatorWidth: CGFloat {
        return SizeConstants.cardWidth / CGFloat(imageCount) - 28
    }
}

#Preview {
    CardImageIndicatorView(currentImageIndex: 1, imageCount: 5)
}
