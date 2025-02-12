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
        do {
            // we start after the last card that was swiped, or from beginning (0 timestamp) if user hasn't swiped yet
            let lastSwipedTimestamp = try Prefs.loadLastSwipedTimestamp() ?? 0
            startFetchCardModels(afterTimestamp: lastSwipedTimestamp)
        } catch {
            print("error retrieving lastSwipedTimestamp: \(error)")
        }
    }
    
    func startFetchCardModels(afterTimestamp: UInt64) {
        Task { await fetchCardModels(afterTimestamp: afterTimestamp) }
    }
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCardModels(afterTimestamp: UInt64) async {
        do {
            let bikes = try await api.getBikes(afterTimestamp: afterTimestamp)
            let prefs = try Prefs.loadBikePrefs()
            let lastSwipedTimestamp = try Prefs.loadLastSwipedTimestamp();
            self.cardModels = filterBikes(bikes, prefs: prefs, lastSwipedTimestamp: lastSwipedTimestamp)
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
    }
    
    func filterBikes(_ bikes: [Bike], prefs: BikePreferences?, lastSwipedTimestamp: UInt64?) -> [Bike] {
        let prefs = prefs ?? nonFilteredPrefs()
        let lastSwipedTimestamp = lastSwipedTimestamp ?? 0
        return bikes.filter { bike in
            // don't show already swiped (left or right) cards again
            (bike.addedTimestamp > lastSwipedTimestamp) &&
            // show only bikes that match preferences
            matchBikeToPrefs(bike: bike, prefs: prefs)
        }
    }
    
    func matchBikeToPrefs(bike: Bike, prefs: BikePreferences) -> Bool {
        // TODO use enum for bike type instead of strings
        (prefs.mountain && bike.type == "mountain") ||
        (prefs.road && bike.type == "road") ||
        (prefs.hybrid && bike.type == "hybrid") ||
        (prefs.price_1 && bike.priceNumber < 500) ||
        (prefs.price_2 && bike.priceNumber >= 500 && bike.priceNumber < 1000) ||
        (prefs.price_3 && bike.priceNumber >= 1000 && bike.priceNumber < 3000) ||
        (prefs.price_4 && bike.priceNumber >= 3000)
    }
    
    // if the user hasn't stored any prefs yet, we don't filter, i.e. accept everything
    func nonFilteredPrefs() -> BikePreferences {
        return BikePreferences(mountain: true, road: true, hybrid: true, price_1: true, price_2: true, price_3: true, price_4: true)
    }
    
    
    func dislike(_ bike: Bike) {
        dontShowAgain(bike)
        do {
            try saveTimestamp(bike)
        } catch {
            print("Error saving timestamp: \(error)")
        }
        removeCard(bike)
    }
    
    func like(_ bike: Bike) {
        dontShowAgain(bike)
        do {
            try saveTimestamp(bike)
        } catch {
            // TODO error handling
            print("Error saving timestamp: \(error)")
        }
        do {
            try saveLike(bike)
        } catch {
            // TODO error handling
            print("Error saving like: \(error)")
        }
        removeCard(bike)

    }
    
    func saveTimestamp(_ bike: Bike) throws {
        try Prefs.saveLastSwipedTimestamp(bike.addedTimestamp)
    }
    
    private func dontShowAgain(_ bike: Bike) {
        // TODO
        // probably add to a json list of ids that's sent to the server each time
        // or if we don't want the server to do filtering (bad e.g. for caching) filter the response with this list in the client
    }
    
    private func removeCard(_ bike: Bike) {
        guard let index = cardModels.firstIndex(where: { $0.id == bike.id }) else { return }
        cardModels.remove(at: index)
        
        // if there are n cards left, fetch the next batch
        // note that we don't need any conditions for "stop fetching batches":
        // when the server doesn't send new items, nothing is added, so if user continues swiping
        // the "n cards left" condition doesn't happen again
        if cardModels.count == 10 {
            if let lastItem = cardModels.last {
                startFetchCardModels(afterTimestamp: lastItem.addedTimestamp)
            } else {
                print("Invalid state: we just checked that there are 10 cardModels, should have `last`")
            }
        }
    }
    
    private func saveLike(_ bike: Bike) throws {
        guard let modelContext = modelContext else {
            print("Invalid state: model context not set")
            return
        }
        
        // don't insert again if it has same id
        // normally this shouldn't happen as already swiped cards shouldn't be presented again
        // but maybe we're not considering edge cases
        let bikeId = bike.id  // Capture the value
        let descriptor = FetchDescriptor<LikedBike>(
            predicate: #Predicate { $0.id == bikeId }
        )
        let likedBikesForId = try modelContext.fetch(descriptor)
        guard likedBikesForId.isEmpty else {
            print("Invalid state: trying to add an already liked object (by id) to likes")
            return
        }

        let currentCount = cardModels.count

        // for now we'll assume that there's no repetition,
        // an item with the same id as an already liked one would not be shown again and thus ux should not allow to like twice
        let like = LikedBike(
            id: bike.id,
            name: bike.name,
            price: bike.price,
            pictures: bike.pictures,
            likedDate: Date(),
            vendorLink: bike.vendorLink,
            type: bike.type,
            descr: bike.descr,
            order: currentCount
        )
        modelContext.insert(like)
        
        do {
            try modelContext.save()
        } catch {
            // TODO error handling
            print("error saving: \(error)")
        }
    }
}
