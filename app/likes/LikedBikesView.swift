import SwiftUI
import SwiftData

struct LikedBikesView: View {
    @Query(sort: [SortDescriptor(\LikedBike.likedDate, order: .forward)])
    private var bikes: [LikedBike]
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
            NavigationSplitView {
                List {
                    ForEach(bikes) { bike in
                        NavigationLink {
                            LikedBikeDetailsView(bike: bike)
                        } label: {
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
                                    Text(bike.type)
                                    Text(bike.electric ? "Electric" : "Non-Electric")
                                }
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Favs")
            } detail: {
                Text("Select a Landmark")
            }
            
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(bikes[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("Error saving: \(error)")
            }
        }
    }
}

