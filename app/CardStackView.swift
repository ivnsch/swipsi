//
//  CardStackView.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import SwiftUI

struct CardStackView: View {
    var body: some View {
        ZStack {
            ForEach(0..<10) { card in
                CardView()
            }
        }
    }
}

#Preview {
    CardStackView()
}
