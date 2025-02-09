import SwiftUI

struct LikedBikeDetailsInfoView: View {
    let bike: BikeInfos

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(bike.name)
                    .font(.title)
                    .fontWeight(.heavy)
                
                VStack {
                    Text(bike.brand)
                        .font(.title)
                        .fontWeight(.semibold)
                    Text(bike.type)
                    Text(bike.electric ? "Electric" : "Non-Electric")
                }
                
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
    }
}

