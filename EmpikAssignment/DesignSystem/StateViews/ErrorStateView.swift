import SwiftUI

struct ErrorStateView: View {
    let reason: String?
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(.errorStateTitle, systemImage: "exclamationmark.triangle")
        } description: {
            if let reason {
                Text(verbatim: reason)
            } else {
                Text(.errorStateDescription)
            }
        } actions: {
            Button(.retryButtonTitle, action: retry)
                .primaryButtonStyle()
        }
    }
}

#Preview("English, without reason") {
    ErrorStateView(reason: nil, retry: {})
}

#Preview("Polish, dark, without reason") {
    ErrorStateView(reason: nil, retry: {})
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Reason from the API") {
    ErrorStateView(reason: "Latitude must be in range of -90 to 90°. Given: 200.0.", retry: {})
}

#Preview("Large text") {
    ErrorStateView(reason: nil, retry: {})
        .dynamicTypeSize(.accessibility3)
}
