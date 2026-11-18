import SwiftUI

struct SearchResultsSection: View {
    let cities: [City]

    var body: some View {
        Section {
            ForEach(cities) { city in
                NavigationLink(value: city) {
                    CityRow(city: city)
                }
            }
        }
    }
}

#Preview("Results") {
    List {
        SearchResultsSection(cities: [.previewKrakow, .previewLodz, .previewSingapore])
    }
}

#Preview("Large text, dark") {
    List {
        SearchResultsSection(cities: [.previewKrakow, .previewLlanfairpwll])
    }
    .dynamicTypeSize(.accessibility3)
    .preferredColorScheme(.dark)
}
