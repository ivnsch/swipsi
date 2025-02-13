import SwiftUI

struct LikedBikeDetailsInfoView: View {
    let bike: BikeInfos

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(bike.name)
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
            }
            HStack {
                Text(bike.type)
                    .padding(4)
                    .borderedBg(color: .black)
            }
            Text(bike.descr)
                .font(.subheadline)
        }
        .padding()
    }
}

struct BikeInfos {
    var name: String
    var price: String
    var type: String
    var descr: String
}
