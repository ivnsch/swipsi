//
//  CardModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation

struct CardModel {
    let item: Item
}

extension CardModel: Identifiable, Hashable {
    var id: String { return item.id }
}
