import Foundation

struct Bike: Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var price: String
    var priceNumber: Float
    var pictures: [String]
    var vendorLink: String
    var type: String
    var gender: String
    var descr: String
    var addedTimestamp: UInt64
}

struct Filters: Codable {
    let type_: [String]
    let gender: [String]
    let price: [Int]
}

class Api: ObservableObject {
    func getBikes(afterTimestamp: UInt64, filters: Filters) async throws -> [Bike] {
//        let url = URL(string: "http://127.0.0.1:8080/bikes")!
        let url = URL(string: "http://192.168.178.24:3000/items/\(afterTimestamp)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let filtersData = try JSONEncoder().encode(filters)
        urlRequest.httpBody = filtersData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decodedBikes = try JSONDecoder().decode([Bike].self, from: data)
            return decodedBikes
        } catch {
            print("Error decoding:", error)
            throw error
        }
    }
}
