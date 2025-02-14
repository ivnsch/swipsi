import SwiftUI
import SwiftData

struct LikedItemsView: View {
    @Query(sort: [SortDescriptor(\LikedItem.order, order: .reverse)])
    private var items: [LikedItem]
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        LikedItemDetailsView(item: item)
                    } label: {
                        LikeView(item: item)
                    }
                }
                .onMove(perform: { indexSet, dest in
                    moveItem(from: indexSet, to: dest)
                })
                .onDelete(perform: deleteItems)
            }
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.mainBg.ignoresSafeArea())
            .navigationTitle("Favs")
        }
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = items
        
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
                modelContext.delete(items[index])
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
    var item: LikedItem

    var body: some View {
        HStack {
            if !item.pictures.isEmpty {
                AsyncImage(url: URL(string: item.pictures[0])) { phase in
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
            }

            VStack(alignment: .leading) {
                Text(item.name)
                Text(toFormattedPrice(item.price, currency: item.priceCurrency))
                HStack {
                    Text(item.type)
                        .font(.system(size: 10))
                        .padding(4)
                        .borderedBgLight(color: .black)
                }
            }
            
        }
    }
}
