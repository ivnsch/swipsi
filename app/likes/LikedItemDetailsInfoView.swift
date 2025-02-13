import SwiftUI

struct LikedItemDetailsInfoView: View {
    let item: ItemInfos

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                HStack {
                    Text(item.type)
                        .padding(4)
                        .borderedBg(color: .black)
                }
                Text(item.descr)
                    .font(.subheadline)
            }
            .padding()
            Text(item.price)
        }
    }
}

struct ItemInfos {
    var name: String
    var price: String
    var type: String
    var descr: String
}
