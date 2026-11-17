import SwiftUI

struct ForecastDetailsView: View {
    let forecast: Forecast

    var body: some View {
        ScrollView {
            GlassCardGroup {
                CurrentWeatherCard(temperature: forecast.current.temperature)
                WeatherConditionsCard(
                    cloudCoverPercent: forecast.current.cloudCoverPercent,
                    precipitationProbabilityPercent: forecast.current.precipitationProbabilityPercent
                )
                HourlyForecastCard(hours: forecast.hourly, timeZone: forecast.timeZone)
            }
            .padding()
        }
    }
}

#Preview("English") {
    ForecastDetailsView(forecast: .previewKrakow)
        .background(SkyGradientBackground())
}

#Preview("Polish, dark") {
    ForecastDetailsView(forecast: .previewKrakow)
        .background(SkyGradientBackground())
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    ForecastDetailsView(forecast: .previewKrakow)
        .background(SkyGradientBackground())
        .dynamicTypeSize(.accessibility3)
}
