import SwiftUI

struct SearchResultsList: View {
    let cities: [City]
    @Binding var selectedCity: City?

    var body: some View {
        List(cities, selection: $selectedCity) { city in
            CityRow(city: city)
                .tag(city)
        }
    }
}

#Preview("Results") {
    SearchResultsList(cities: [.previewKrakow, .previewLodz, .previewSingapore], selectedCity: .constant(nil))
}

#Preview("Large text, dark") {
    SearchResultsList(cities: [.previewKrakow, .previewLlanfairpwll], selectedCity: .constant(nil))
        .dynamicTypeSize(.accessibility3)
        .preferredColorScheme(.dark)
}
