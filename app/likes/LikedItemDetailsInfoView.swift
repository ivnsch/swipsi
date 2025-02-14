import SwiftUI

struct LikedItemDetailsInfoView: View {
    let item: ItemInfos

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                HStack {
                    Text(item.type)
                        .padding(4)
                        .borderedBg(color: .black)
                }
                Text(toFormattedPrice(item.price, currency: item.priceCurrency))
                    .fontWeight(.heavy)

                Text(item.descr)
                    .font(.subheadline)
            }
            .padding()
        }

    }
}

struct ItemInfos {
    var name: String
    var price: String
    var priceCurrency: String
    var type: String
    var descr: String
}
