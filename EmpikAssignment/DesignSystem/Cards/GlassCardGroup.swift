import SwiftUI

struct GlassCardGroup<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        let cards = VStack(spacing: Spacing.medium) { content }
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: Spacing.medium) { cards }
        } else {
            cards
        }
    }
}

private struct GlassCardGroupPreview: View {
    var body: some View {
        GlassCardGroup {
            Card { Text(verbatim: "First card") }
            Card { Text(verbatim: "Second card") }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(SkyGradientBackground())
    }
}

#Preview("Light") {
    GlassCardGroupPreview()
}

#Preview("Dark") {
    GlassCardGroupPreview()
        .preferredColorScheme(.dark)
}
