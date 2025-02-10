import SwiftUI
import SwiftData

struct LikedBikesView: View {
    @Query(sort: [SortDescriptor(\LikedBike.order, order: .forward)])
    private var bikes: [LikedBike]
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
            NavigationSplitView {
                List {
                    ForEach(bikes) { bike in
                        NavigationLink {
                            LikedBikeDetailsView(bike: bike)
                        } label: {
                            LikeView(bike: bike)
                        }
                    }
                    .onMove(perform: { indexSet, dest in
                        moveItem(from: indexSet, to: dest)
                    })
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Favs")
            } detail: {
                Text("Select a Landmark")
            }
            
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = bikes
        
        updatedItems.move(fromOffsets: source, toOffset: destination)

        for (index, item) in updatedItems.enumerated() {
            item.order = index
        }

        // we'll just ignore errors here as moving items can be seen as non critical..
        try? modelContext.save()
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

private struct LikeView: View {
    var bike: LikedBike

    var body: some View {
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
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading) {
                Text(bike.name)
                Text(bike.brand)
                Text(bike.price)
                HStack {
                    Text(bike.type)
                        .font(.system(size: 10))
                        .padding(4)
                        .borderedBgLight(color: .black)
                    Text(bike.electric ? "Electric" : "Non-Electric")
                        .font(.system(size: 10))
                        .padding(4)
                        .borderedBgLight(color: .black)
                }
            }
            
        }
    }
}
