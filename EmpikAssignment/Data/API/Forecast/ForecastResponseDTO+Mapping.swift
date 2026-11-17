import Foundation

extension ForecastResponseDTO {
    nonisolated func toForecast() throws(ForecastMappingError) -> Forecast {
        guard let timeZone = TimeZone(identifier: timezone) else {
            throw .unknownTimeZone(timezone)
        }
        guard
            hourly.temperature2m.count == hourly.time.count,
            hourly.precipitationProbability.count == hourly.time.count
        else {
            throw .hourlyValuesCountMismatch
        }
        let currentTemperatureUnit = try temperatureUnit(from: currentUnits.temperature2m)
        let hourlyTemperatureUnit = try temperatureUnit(from: hourlyUnits.temperature2m)

        let currentWeather = CurrentWeather(
            temperature: Measurement(value: current.temperature2m, unit: currentTemperatureUnit),
            cloudCoverPercent: current.cloudCover,
            precipitationProbabilityPercent: current.precipitationProbability
        )
        let hourlyForecasts = hourly.time.indices.map { index in
            HourlyForecast(
                date: Date(timeIntervalSince1970: TimeInterval(hourly.time[index])),
                temperature: Measurement(value: hourly.temperature2m[index], unit: hourlyTemperatureUnit),
                precipitationProbabilityPercent: hourly.precipitationProbability[index]
            )
        }
        return Forecast(current: currentWeather, hourly: hourlyForecasts, timeZone: timeZone)
    }

    private nonisolated func temperatureUnit(from symbol: String) throws(ForecastMappingError) -> UnitTemperature {
        switch symbol {
        case "°C": .celsius
        case "°F": .fahrenheit
        default: throw .unknownTemperatureUnit(symbol)
        }
    }
}
