import SwiftUI

struct LoadingStateView: View {
    var body: some View {
        ProgressView {
            Text(.loadingStateTitle)
        }
    }
}

#Preview("English") {
    LoadingStateView()
}

#Preview("Polish, dark") {
    LoadingStateView()
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    LoadingStateView()
        .dynamicTypeSize(.accessibility3)
}
