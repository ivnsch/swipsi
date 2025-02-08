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

        Task { await fetchCardModels() }
    }
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCardModels() async {
        do {
            self.cardModels = try await api.getBikes()
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
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
        let like = LikedBike(id: bike.id, name: bike.name, brand: bike.brand, price: bike.price, pictures: bike.pictures, likedDate: Date())
        modelContext.insert(like)
    }
}
