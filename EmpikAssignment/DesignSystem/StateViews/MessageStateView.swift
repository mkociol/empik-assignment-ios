import SwiftUI

struct MessageStateView<Actions: View>: View {
    let title: LocalizedStringResource
    let systemImage: String
    let description: Text
    @ViewBuilder let actions: Actions

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            description
        } actions: {
            actions
        }
    }
}

extension MessageStateView where Actions == EmptyView {
    init(title: LocalizedStringResource, systemImage: String, description: Text) {
        self.init(title: title, systemImage: systemImage, description: description) {}
    }
}

#Preview("Without actions") {
    MessageStateView(
        title: .offlineStateTitle,
        systemImage: "wifi.slash",
        description: Text(.offlineStateDescription)
    )
}

#Preview("With actions, dark") {
    MessageStateView(
        title: .errorStateTitle,
        systemImage: "exclamationmark.triangle",
        description: Text(.errorStateDescription)
    ) {
        RetryButton(action: {})
    }
    .preferredColorScheme(.dark)
}
