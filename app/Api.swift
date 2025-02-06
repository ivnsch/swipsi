import Foundation

struct Bike: Identifiable, Decodable {
    var id: String
    var name: String
    var brand: String
    var price: String
    var picture: String
}

class Api: ObservableObject {
    @Published var bikes: [Bike] = []

    func getBikes() {
        let url = URL(string: "http://127.0.0.1:8080/bikes")!

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedBikes = try JSONDecoder().decode([Bike].self, from: data)
                        self.bikes = decodedBikes
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
