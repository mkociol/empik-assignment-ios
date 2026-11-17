import Foundation

nonisolated struct ForecastRequest: OpenMeteoRequest {
    typealias Response = ForecastResponseDTO

    let latitude: Double
    let longitude: Double
    let temperatureUnit: OpenMeteoTemperatureUnit

    func url(configuration: OpenMeteoConfiguration) -> URL {
        configuration.forecastAPIBaseURL
            .appending(path: "forecast")
            .appending(queryItems: [
                URLQueryItem(name: "latitude", value: String(latitude)),
                URLQueryItem(name: "longitude", value: String(longitude)),
                URLQueryItem(name: "current", value: "temperature_2m,cloud_cover,precipitation_probability"),
                URLQueryItem(name: "hourly", value: "temperature_2m,precipitation_probability"),
                URLQueryItem(name: "forecast_hours", value: "24"),
                URLQueryItem(name: "timezone", value: "auto"),
                URLQueryItem(name: "timeformat", value: "unixtime"),
                URLQueryItem(name: "temperature_unit", value: temperatureUnit.rawValue)
            ])
    }
}
