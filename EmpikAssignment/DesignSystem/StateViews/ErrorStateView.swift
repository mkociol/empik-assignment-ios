import SwiftUI

struct ErrorStateView: View {
    let reason: String?
    let retry: () -> Void

    var body: some View {
        MessageStateView(
            title: .errorStateTitle,
            systemImage: "exclamationmark.triangle",
            description: reason.map { Text(verbatim: $0) } ?? Text(.errorStateDescription)
        ) {
            RetryButton(action: retry)
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
