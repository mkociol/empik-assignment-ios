import SwiftUI

struct CityRow: View {
    let city: City

    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: city.name)
            if let region = city.region {
                Text(verbatim: region)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
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
