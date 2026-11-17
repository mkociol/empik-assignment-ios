import SwiftUI

struct WeatherConditionsCard: View {
    let cloudCoverPercent: Int
    let precipitationProbabilityPercent: Int?

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.small) {
                WeatherConditionRow(
                    title: .weatherConditionsCloudCover,
                    systemImage: "cloud.fill",
                    percent: cloudCoverPercent
                )
                WeatherConditionRow(
                    title: .weatherConditionsPrecipitationProbability,
                    systemImage: "umbrella.fill",
                    percent: precipitationProbabilityPercent
                )
            }
        }
    }
}

private struct WeatherConditionRow: View {
    let title: LocalizedStringResource
    let systemImage: String
    let percent: Int?

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            PercentageText(percent: percent)
                .font(.headline)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("English") {
    WeatherConditionsCard(cloudCoverPercent: 100, precipitationProbabilityPercent: 98)
        .padding()
        .background(SkyGradientBackground())
}

#Preview("Polish, dark, no precipitation data") {
    WeatherConditionsCard(cloudCoverPercent: 100, precipitationProbabilityPercent: nil)
        .padding()
        .background(SkyGradientBackground())
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    WeatherConditionsCard(cloudCoverPercent: 100, precipitationProbabilityPercent: 98)
        .padding()
        .background(SkyGradientBackground())
        .dynamicTypeSize(.accessibility3)
}
