import SwiftUI
import SwiftData

struct LikedBikesView: View {
    @Query(sort: [SortDescriptor(\LikedBike.likedDate, order: .forward)])
    private var bikes: [LikedBike]

    var body: some View {
        List {
            ForEach(bikes) { bike in
                HStack {
                    // TODO handle no pic
                    AsyncImage(url: URL(string: bike.pictures[0])) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(bike.name)
                        Text(bike.brand)
                        Text(bike.price)
                    }
                    
                }
            }
        }
    }
}

