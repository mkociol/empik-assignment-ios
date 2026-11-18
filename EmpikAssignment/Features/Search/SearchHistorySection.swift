import SwiftUI

struct SearchHistorySection: View {
    let cities: [City]
    let onDelete: (City) -> Void

    var body: some View {
        Section {
            ForEach(cities) { city in
                NavigationLink(value: city) {
                    CityRow(city: city)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        onDelete(city)
                    } label: {
                        Label(.searchHistoryDeleteButton, systemImage: "trash")
                    }
                }
            }
        } header: {
            Text(.searchHistoryHeader)
        }
    }
}

#Preview("English") {
    List {
        SearchHistorySection(cities: [.previewSingapore, .previewKrakow, .previewLodz], onDelete: { _ in })
    }
}

#Preview("Polish, dark") {
    List {
        SearchHistorySection(cities: [.previewSingapore, .previewKrakow, .previewLodz], onDelete: { _ in })
    }
    .environment(\.locale, Locale(identifier: "pl"))
    .preferredColorScheme(.dark)
}

#Preview("Large text") {
    List {
        SearchHistorySection(cities: [.previewKrakow, .previewLlanfairpwll], onDelete: { _ in })
    }
    .dynamicTypeSize(.accessibility3)
}
