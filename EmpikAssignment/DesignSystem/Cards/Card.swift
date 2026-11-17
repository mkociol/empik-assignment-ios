import SwiftUI

struct Card<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardBackground()
    }
}

private extension View {
    @ViewBuilder
    func cardBackground() -> some View {
        let shape = RoundedRectangle(cornerRadius: 20)
        if #available(iOS 26, *) {
            glassEffect(.regular, in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
        }
    }
}

private struct CardPreview: View {
    var body: some View {
        Card {
            VStack(alignment: .leading) {
                Text(verbatim: "Kraków")
                    .font(.headline)
                Text(verbatim: "5.7°")
                    .font(.largeTitle)
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(LinearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottom))
    }
}

#Preview("Light") {
    CardPreview()
}

#Preview("Dark") {
    CardPreview()
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    CardPreview()
        .dynamicTypeSize(.accessibility3)
}
