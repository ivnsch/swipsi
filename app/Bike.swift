import Foundation

struct Bike: Identifiable, Hashable {
    let id: String
    let name: String
    var brand: String
    var imageUrls: [String]
}
