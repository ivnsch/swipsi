//
//  CardsViewModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels: [CardModel] = []
    
    private let service: CardService
    
    init(service: CardService) {
        self.service = service
        Task { await fetchCardModels() }
    }
    
    func fetchCardModels() async {
        do {
            self.cardModels = try await service.fetchCardModels()
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
    }
    
    func removeCard(_ card: CardModel) {
        guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
        cardModels.remove(at: index)
    }
}
