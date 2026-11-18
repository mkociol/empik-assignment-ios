import SwiftUI

struct CityRow: View {
    let city: City

    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: city.name)
            CityLocationText(region: city.region, country: city.country)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct CityLocationText: View {
    let region: String?
    let country: String?

    var body: some View {
        if let region, let country {
            Text(.cityRowLocation(region, country))
        } else if let place = region ?? country {
            Text(verbatim: place)
        }
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
