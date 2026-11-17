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
    Button(.retryButtonTitle) {}
        .primaryButtonStyle()
}

#Preview("Dark") {
    Button(.retryButtonTitle) {}
        .primaryButtonStyle()
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    Button(.retryButtonTitle) {}
        .primaryButtonStyle()
        .dynamicTypeSize(.accessibility3)
}
