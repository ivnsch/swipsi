import Foundation

struct MockData {
    static let bikes: [Bike] = [
        .init(
            id: NSUUID().uuidString,
            name: "Bike123",
            brand: "Brand123",
            imageUrls: ["bike", "bike2"]
        ),
        .init(
            id: NSUUID().uuidString,
            name: "Bike124",
            brand: "Brand124",
            imageUrls: ["bike", "bike2"]
        ),
        .init(
            id: NSUUID().uuidString,
            name: "Bike125",
            brand: "Brand125",
            imageUrls: ["bike", "bike2"]
        )
    ]
}
