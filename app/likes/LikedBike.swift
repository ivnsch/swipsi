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
    var vendorLink: String = ""
    var type: String = ""
    var electric: Bool = false
    var descr: String = ""
    
    init(id: String, name: String, brand: String, price: String, pictures: [String], likedDate: Date, vendorLink: String, type: String, electric: Bool, descr: String) {
        self.id = id
        self.name = name
        self.brand = brand
        self.price = price
        self.pictures = pictures
        self.likedDate = likedDate
        self.vendorLink = vendorLink
        self.type = type
        self.electric = electric
        self.descr = descr
    }
}
