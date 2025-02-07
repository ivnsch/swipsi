//
//  CardModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation

struct CardModel {
    let bike: Bike
}

extension CardModel: Identifiable, Hashable {
    var id: String { return bike.id }
}
