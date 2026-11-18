import SwiftUI

struct CityRow: View {
    let city: City

    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: city.name)
            if let location {
                Text(verbatim: location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var location: String? {
        let parts = [city.region, city.country].compactMap(\.self)
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}

#Preview("With region") {
    List { CityRow(city: .previewKrakow) }
}

#Preview("Without region") {
    List { CityRow(city: .previewSingapore) }
}

#Preview("Long name, large text, dark") {
    List { CityRow(city: .previewLlanfairpwll) }
        .dynamicTypeSize(.accessibility3)
        .preferredColorScheme(.dark)
}
