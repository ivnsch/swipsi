//
//  CardsViewModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels: [Bike] = []
    
    var modelContext: ModelContext?

    private let api: Api
    
    init(api: Api) {
        self.api = api
    }
    
    func startFetchCardModels() {
        Task { await fetchCardModels() }
    }
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCardModels() async {
        do {
            let bikes = try await api.getBikes()
            let prefs = try Prefs.loadBikePrefs()
            self.cardModels = filterBikes(bikes, prefs: prefs)
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
    }
    
    func filterBikes(_ bikes: [Bike], prefs: BikePreferences?) -> [Bike] {
        let prefs = prefs ?? nonFilteredPrefs()
        
        return bikes.filter { bike in
            // TODO use enum for bike type instead of strings
            (prefs.mountain && bike.type == "mountain") ||
            (prefs.road && bike.type == "road") ||
            (prefs.hybrid && bike.type == "hybrid") ||
            (prefs.electric && bike.electric) ||
            (prefs.nonElectric && !bike.electric) ||
            (prefs.price_1 && bike.priceNumber < 500) ||
            (prefs.price_2 && bike.priceNumber >= 500 && bike.priceNumber < 1000) ||
            (prefs.price_3 && bike.priceNumber >= 1000 && bike.priceNumber < 3000) ||
            (prefs.price_4 && bike.priceNumber >= 3000)
        }
    }
    
    // if the user hasn't stored any prefs yet, we don't filter, i.e. accept everything
    func nonFilteredPrefs() -> BikePreferences {
        return BikePreferences(mountain: true, road: true, hybrid: true, electric: true, nonElectric: true,
                                    price_1: true, price_2: true, price_3: true, price_4: true)
    }
    
    
    func dislike(_ bike: Bike) {
        dontShowAgain(bike)
        removeCard(bike)
    }
    
    func like(_ bike: Bike) {
        dontShowAgain(bike)
        saveLike(bike)
        removeCard(bike)
    }
    
    private func dontShowAgain(_ bike: Bike) {
        // TODO
        // probably add to a json list of ids that's sent to the server each time
        // or if we don't want the server to do filtering (bad e.g. for caching) filter the response with this list in the client
    }
    
    private func removeCard(_ bike: Bike) {
        guard let index = cardModels.firstIndex(where: { $0.id == bike.id }) else { return }
        cardModels.remove(at: index)
    }
    
    private func saveLike(_ bike: Bike) {
        guard let modelContext = modelContext else {
            print("Invalid state: model context not set")
            return
        }
        
        // for now we'll assume that there's no repetition,
        // an item with the same id as an already liked one would not be shown again and thus ux should not allow to like twice
        let like = LikedBike(
            id: bike.id,
            name: bike.name,
            brand: bike.brand,
            price: bike.price,
            pictures: bike.pictures,
            likedDate: Date(),
            vendorLink: bike.vendorLink,
            type: bike.type,
            electric: bike.electric,
            descr: bike.descr
        )
        modelContext.insert(like)
    }
}
