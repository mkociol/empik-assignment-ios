import SwiftUI

extension View {
    @ViewBuilder
    func primaryButtonStyle() -> some View {
        if #available(iOS 26, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
        }
    }
}

#Preview("Light") {
    Button("Try Again") {}
        .primaryButtonStyle()
}

#Preview("Dark") {
    Button("Try Again") {}
        .primaryButtonStyle()
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    Button("Try Again") {}
        .primaryButtonStyle()
        .dynamicTypeSize(.accessibility3)
}
