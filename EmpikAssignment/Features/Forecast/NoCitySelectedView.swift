import SwiftUI

struct NoCitySelectedView: View {
    var body: some View {
        MessageStateView(
            title: .noCitySelectedTitle,
            systemImage: "cloud.sun",
            description: Text(.noCitySelectedDescription)
        )
    }
}

#Preview("English") {
    NoCitySelectedView()
}

#Preview("Polish, dark") {
    NoCitySelectedView()
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    NoCitySelectedView()
        .dynamicTypeSize(.accessibility3)
}
