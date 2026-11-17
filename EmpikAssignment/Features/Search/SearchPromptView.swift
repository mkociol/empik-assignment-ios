import SwiftUI

struct SearchPromptView: View {
    var body: some View {
        MessageStateView(
            title: .searchPromptTitle,
            systemImage: "magnifyingglass",
            description: Text(.searchPromptDescription)
        )
    }
}

#Preview("English") {
    SearchPromptView()
}

#Preview("Polish, dark") {
    SearchPromptView()
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    SearchPromptView()
        .dynamicTypeSize(.accessibility3)
}
