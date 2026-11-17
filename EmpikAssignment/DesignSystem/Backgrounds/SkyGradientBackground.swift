import SwiftUI

struct SkyGradientBackground: View {
    var body: some View {
        LinearGradient(colors: [.skyGradientTop, .skyGradientBottom], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview("Light") {
    SkyGradientBackground()
}

#Preview("Dark") {
    SkyGradientBackground()
        .preferredColorScheme(.dark)
}
