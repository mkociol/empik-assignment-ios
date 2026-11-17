#if DEBUG
import Foundation

extension Forecast {
    /// Recorded real response for Kraków (forecast_hours=24, temperature_unit=celsius).
    nonisolated static let previewKrakow = Forecast(
        current: CurrentWeather(
            temperature: Measurement(value: 6.2, unit: .celsius),
            cloudCoverPercent: 100,
            precipitationProbabilityPercent: 98
        ),
        hourly: krakowHours.map { hour in
            HourlyForecast(
                date: Date(timeIntervalSince1970: hour.unixTime),
                temperature: Measurement(value: hour.celsius, unit: .celsius),
                precipitationProbabilityPercent: hour.precipitationPercent
            )
        },
        timeZone: TimeZone(identifier: "Europe/Warsaw")!
    )
}

private nonisolated let krakowHours: [(unixTime: TimeInterval, celsius: Double, precipitationPercent: Int)] = [
    (1_794_938_400, 6.2, 98), (1_794_942_000, 6.2, 100), (1_794_945_600, 6.7, 100), (1_794_949_200, 6.7, 100),
    (1_794_952_800, 6.7, 80), (1_794_956_400, 9.2, 52), (1_794_960_000, 9.5, 29), (1_794_963_600, 9.0, 15),
    (1_794_967_200, 7.6, 5), (1_794_970_800, 6.4, 0), (1_794_974_400, 5.4, 0), (1_794_978_000, 5.6, 1),
    (1_794_981_600, 6.4, 10), (1_794_985_200, 7.6, 34), (1_794_988_800, 7.2, 64), (1_794_992_400, 7.8, 80),
    (1_794_996_000, 10.1, 70), (1_794_999_600, 11.8, 45), (1_795_003_200, 12.1, 25), (1_795_006_800, 12.0, 15),
    (1_795_010_400, 11.3, 9), (1_795_014_000, 10.3, 6), (1_795_017_600, 10.2, 6), (1_795_021_200, 9.1, 8)
]
#endif
