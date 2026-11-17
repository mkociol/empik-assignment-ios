import Foundation
import Testing
@testable import EmpikAssignment

struct ForecastResponseDTOTests {
    @Test func mapsCurrentWeather() throws {
        let forecast = try decodeForecastResponse(krakowResponse).toForecast()

        #expect(forecast.current == CurrentWeather(
            temperature: Measurement(value: 5.7, unit: .celsius),
            cloudCoverPercent: 100,
            precipitationProbabilityPercent: 85
        ))
    }

    @Test func mapsHourlyForecastInOrder() throws {
        let forecast = try decodeForecastResponse(krakowResponse).toForecast()

        #expect(forecast.hourly == [
            HourlyForecast(
                date: Date(timeIntervalSince1970: 1_794_913_200),
                temperature: Measurement(value: 5.7, unit: .celsius),
                precipitationProbabilityPercent: 90
            ),
            HourlyForecast(
                date: Date(timeIntervalSince1970: 1_794_916_800),
                temperature: Measurement(value: 5.9, unit: .celsius),
                precipitationProbabilityPercent: 78
            ),
            HourlyForecast(
                date: Date(timeIntervalSince1970: 1_794_920_400),
                temperature: Measurement(value: 6.5, unit: .celsius),
                precipitationProbabilityPercent: 50
            )
        ])
    }

    @Test func mapsTimeZoneOfCity() throws {
        let forecast = try decodeForecastResponse(krakowResponse).toForecast()

        #expect(forecast.timeZone == TimeZone(identifier: "Europe/Warsaw"))
    }

    @Test func mapsMissingPrecipitationProbabilityToNil() throws {
        let response = krakowResponse.replacingOccurrences(of: "[90,78,50]", with: "[90,null,50]")

        let forecast = try decodeForecastResponse(response).toForecast()

        #expect(forecast.hourly.map(\.precipitationProbabilityPercent) == [90, nil, 50])
    }

    @Test func mapsTemperaturesInFahrenheitWhenResponseUsesFahrenheit() throws {
        let response = krakowResponse.replacingOccurrences(of: "°C", with: "°F")

        let forecast = try decodeForecastResponse(response).toForecast()

        #expect(forecast.current.temperature == Measurement(value: 5.7, unit: .fahrenheit))
        #expect(forecast.hourly.map(\.temperature.unit) == [.fahrenheit, .fahrenheit, .fahrenheit])
    }

    @Test func throwsForUnknownTemperatureUnit() {
        let response = krakowResponse.replacingOccurrences(of: "°C", with: "K")

        #expect(throws: ForecastMappingError.unknownTemperatureUnit("K")) {
            try decodeForecastResponse(response).toForecast()
        }
    }

    @Test func throwsForUnknownTimeZone() {
        let response = krakowResponse.replacingOccurrences(of: "Europe/Warsaw", with: "Mars/Olympus_Mons")

        #expect(throws: ForecastMappingError.unknownTimeZone("Mars/Olympus_Mons")) {
            try decodeForecastResponse(response).toForecast()
        }
    }

    @Test func throwsWhenHourlyValuesHaveDifferentCounts() {
        let response = krakowResponse.replacingOccurrences(of: "[5.7,5.9,6.5]", with: "[5.7,5.9]")

        #expect(throws: ForecastMappingError.hourlyValuesCountMismatch) {
            try decodeForecastResponse(response).toForecast()
        }
    }

    /// Real response for Kraków (forecast_hours=3, timeformat=unixtime).
    private let krakowResponse = """
    {"latitude":50.057274,"longitude":19.949356,"generationtime_ms":0.08809566497802734,"utc_offset_seconds":3600,\
    "timezone":"Europe/Warsaw","timezone_abbreviation":"GMT+1","elevation":220.0,\
    "current_units":{"time":"unixtime","interval":"seconds","temperature_2m":"°C","cloud_cover":"%",\
    "precipitation_probability":"%"},\
    "current":{"time":1794915000,"interval":900,"temperature_2m":5.7,"cloud_cover":100,"precipitation_probability":85},\
    "hourly_units":{"time":"unixtime","temperature_2m":"°C","precipitation_probability":"%"},\
    "hourly":{"time":[1794913200,1794916800,1794920400],"temperature_2m":[5.7,5.9,6.5],\
    "precipitation_probability":[90,78,50]}}
    """

    private func decodeForecastResponse(_ json: String) throws -> ForecastResponseDTO {
        try JSONDecoder().decode(ForecastResponseDTO.self, from: Data(json.utf8))
    }
}
