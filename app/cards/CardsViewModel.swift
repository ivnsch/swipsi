//
//  CardsViewModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels: [Bike] = []
    
    private let api: Api
    
    init(api: Api) {
        self.api = api
        Task { await fetchCardModels() }
    }
    
    func fetchCardModels() async {
        do {
            self.cardModels = try await api.getBikes()
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
    }
    
    func removeCard(_ card: Bike) {
        guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
        cardModels.remove(at: index)
    }
}
