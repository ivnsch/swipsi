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
                }
                
                Spacer()
            }
            HStack {
                Text(bike.type)
                    .padding(4)
                    .borderedBg(color: .black)
                Text(bike.electric ? "Electric" : "Non-Electric")
                    .padding(4)
                    .borderedBg(color: .black)
            }
            Text("Mountain bike")
                .font(.subheadline)
                .lineLimit(2)
        }
        .padding()
    }
}

