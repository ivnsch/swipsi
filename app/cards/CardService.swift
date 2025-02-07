//
//  CardService.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation

struct CardService {

    func fetchCardModels() async throws -> [CardModel] {
        let bikes = MockData.bikes
        return bikes.map({ CardModel(bike: $0) })
        
    }
}
