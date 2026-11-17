import SwiftUI

struct EmptySearchResultView: View {
    let query: String

    var body: some View {
        ContentUnavailableView {
            Label(.emptySearchResultTitle, systemImage: "magnifyingglass")
        } description: {
            Text(.emptySearchResultDescription(query))
        }
    }
}

#Preview("English") {
    EmptySearchResultView(query: "Xyzqwv")
}

#Preview("Polish, dark") {
    EmptySearchResultView(query: "Xyzqwv")
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    EmptySearchResultView(query: "Xyzqwv")
        .dynamicTypeSize(.accessibility3)
}
