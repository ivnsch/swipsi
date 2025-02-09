import Foundation
import SwiftUI

extension View {
    
    func borderedBg(color: Color = .white) -> some View {
        return background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .stroke(color, lineWidth: 2)
        )
    }
}
