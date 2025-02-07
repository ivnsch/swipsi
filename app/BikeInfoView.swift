//
//  BikeInfo.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import SwiftUI

struct BikeInfoView: View {

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Bike 123")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Brand 123")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    print("debug: show profile")
                    
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .fontWeight(.bold)
                        .imageScale(.large)
                }
            }
            Text("Mountain bike")
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

#Preview {
    BikeInfoView()
}
