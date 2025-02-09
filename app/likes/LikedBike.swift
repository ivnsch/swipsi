import Foundation
import SwiftData

@Model
final class LikedBike: Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var brand: String = ""
    var price: String = ""
    var picturesString: String = ""
    var likedDate: Date = Date()
    var vendorLink: String = ""
    var type: String = ""
    var electric: Bool = false
    var descr: String = ""
    var order: Int = 0
    
    var pictures: [String] {
           get {
               picturesString.isEmpty ? [] : picturesString.components(separatedBy: ",")
           }
           set {
               picturesString = newValue.joined(separator: ",")
           }
       }
    
    init(id: String, name: String, brand: String, price: String, pictures: [String], likedDate: Date, vendorLink: String, type: String, electric: Bool, descr: String, order: Int) {
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
        self.order = order
    }
}
