import SwiftUI

struct LargeDisplayFontModifier: ViewModifier {
    @ScaledMetric(relativeTo: .largeTitle) private var size: CGFloat = 72

    func body(content: Content) -> some View {
        content.font(.system(size: size, weight: .thin, design: .rounded))
    }
}

extension View {
    func largeDisplayFont() -> some View {
        modifier(LargeDisplayFontModifier())
    }
}

#Preview("Light") {
    Text(verbatim: "10°C")
        .largeDisplayFont()
}

#Preview("Dark") {
    Text(verbatim: "10°C")
        .largeDisplayFont()
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    Text(verbatim: "10°C")
        .largeDisplayFont()
        .dynamicTypeSize(.accessibility3)
}
