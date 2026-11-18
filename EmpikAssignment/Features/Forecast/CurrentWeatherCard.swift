import SwiftUI

struct CurrentWeatherCard: View {
    let temperature: Measurement<UnitTemperature>

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(.currentWeatherTitle)
                    .font(.headline)
                Text(temperature, format: .weatherTemperature)
                    .largeDisplayFont()
            }
            .accessibilityElement(children: .combine)
        }
    }
}

#Preview("English") {
    CurrentWeatherCard(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
}

#Preview("Polish, dark") {
    CurrentWeatherCard(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    CurrentWeatherCard(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
        .dynamicTypeSize(.accessibility3)
}
