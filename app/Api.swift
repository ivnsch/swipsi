import Foundation

struct Item: Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var price: String
    var priceNumber: Float
    var priceCurrency: String
    var pictures: [String]
    var vendorLink: String
    var type: String
    var descr: String
    var addedTimestamp: UInt64
}

struct Filters: Codable {
    let type_: [String]
    let price: [Int]
}

class Api: ObservableObject {
    func getItems(afterTimestamp: UInt64, filters: Filters) async throws -> [Item] {
//        let url = URL(string: "http://127.0.0.1:8080/items/\(afterTimestamp)")!
        let url = URL(string: "https://api.swipsi.com/items/\(afterTimestamp)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let filtersData = try JSONEncoder().encode(filters)
        urlRequest.httpBody = filtersData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("🔴 bad response:", response)
            throw URLError(.badServerResponse)
        }

        do {
            let decodedItems = try JSONDecoder().decode([Item].self, from: data)
            return decodedItems
        } catch {
            print("🔴 Error decoding:", error)
            throw error
        }
    }
}
