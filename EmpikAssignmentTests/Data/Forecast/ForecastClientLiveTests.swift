import Foundation
import Testing
@testable import EmpikAssignment

struct ForecastClientLiveTests {
    private let configuration = OpenMeteoConfiguration.example

    @Test func requestsPreferredTemperatureUnitAndReturnsForecast() async throws {
        let httpClient = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            #expect(url.query()?.contains("temperature_unit=fahrenheit") == true)
            return (
                Data(krakowFahrenheitResponse.utf8),
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        })
        let client = ForecastClient.live(httpClient: httpClient, preferredTemperatureUnit: { .fahrenheit })

        let forecast = try await client.fetchForecast(Coordinates(latitude: 50.06143, longitude: 19.93658))

        #expect(forecast.current.temperature == Measurement(value: 42.6, unit: .fahrenheit))
        #expect(forecast.hourly.count == 2)
    }

    /// Recorded real response for Kraków (forecast_hours=2, temperature_unit=fahrenheit).
    private let krakowFahrenheitResponse = """
    {"latitude":50.064266,"longitude":19.923676,"generationtime_ms":0.09012222290039062,"utc_offset_seconds":3600,\
    "timezone":"Europe/Warsaw","timezone_abbreviation":"GMT+1","elevation":214.0,\
    "current_units":{"time":"unixtime","interval":"seconds","temperature_2m":"°F","cloud_cover":"%",\
    "precipitation_probability":"%"},\
    "current":{"time":1794924900,"interval":900,"temperature_2m":42.6,"cloud_cover":100,"precipitation_probability":9},\
    "hourly_units":{"time":"unixtime","temperature_2m":"°F","precipitation_probability":"%"},\
    "hourly":{"time":[1794924000,1794927600],"temperature_2m":[42.6,42.6],"precipitation_probability":[15,0]}}
    """
}
