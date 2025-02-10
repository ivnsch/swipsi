import Foundation
import SwiftUI

extension View {
    
    func borderedBg(color: Color) -> some View {
        return background(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .stroke(color, lineWidth: 2)
        )
    }
    
    func borderedBgLight(color: Color) -> some View {
        return background(
            RoundedRectangle(
                cornerRadius: 6,
                style: .continuous
            )
            .stroke(color, lineWidth: 1)
        )
    }
}
