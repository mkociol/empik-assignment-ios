import SwiftUI

struct OfflineStateView: View {
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(.offlineStateTitle, systemImage: "wifi.slash")
        } description: {
            Text(.offlineStateDescription)
        } actions: {
            Button(.retryButtonTitle, action: retry)
                .primaryButtonStyle()
        }
    }
}

#Preview("English") {
    OfflineStateView(retry: {})
}

#Preview("Polish, dark") {
    OfflineStateView(retry: {})
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    OfflineStateView(retry: {})
        .dynamicTypeSize(.accessibility3)
}
