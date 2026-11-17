import SwiftUI

struct RetryButton: View {
    let action: () -> Void

    var body: some View {
        Button(.retryButtonTitle, action: action)
            .primaryButtonStyle()
    }
}

#Preview("English") {
    RetryButton(action: {})
}

#Preview("Polish, dark") {
    RetryButton(action: {})
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}
