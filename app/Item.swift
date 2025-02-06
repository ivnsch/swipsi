//
//  Item.swift
//  app
//
//  Created by Ivan Schuetz on 06.02.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
