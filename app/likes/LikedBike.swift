import Foundation
import SwiftData

@Model
final class LikedBike: Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var brand: String = ""
    var price: String = ""
    var pictures: [String] = []
    var likedDate: Date = Date()
    
    init(id: String, name: String, brand: String, price: String, pictures: [String], likedDate: Date) {
        self.id = id
        self.name = name
        self.brand = brand
        self.price = price
        self.pictures = pictures
        self.likedDate = likedDate
    }
}
