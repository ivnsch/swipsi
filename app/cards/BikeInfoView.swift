//
//  BikeInfo.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import SwiftUI

struct BikeInfoView: View {
    let bike: BikeInfos

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(bike.name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .lineLimit(2)
                Spacer()
            }
            HStack {
                Text(bike.type)
                    .padding(4)
                    .borderedBg(color: .white)
            }
            Text(bike.descr)
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding()
        .background(
            LinearGradient(colors: [.clear, .black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
        )
        .foregroundStyle(.white)

    }
}

// common lightweight class to use this from places with different models
struct BikeInfos {
    var name: String
    var price: String
    var type: String
    var descr: String
}
