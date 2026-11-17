import Foundation
import Testing
@testable import EmpikAssignment

struct ForecastRequestTests {
    private let configuration = OpenMeteoConfiguration.example
    private let krakow = Coordinates(latitude: 50.06143, longitude: 19.93658)

    @Test func buildsURL() {
        let request = ForecastRequest(coordinates: krakow, temperatureUnit: .celsius)

        #expect(request.url(configuration: configuration).absoluteString == "https://forecast.example.com/v1/forecast"
            + "?latitude=50.06143&longitude=19.93658"
            + "&current=temperature_2m,cloud_cover,precipitation_probability"
            + "&hourly=temperature_2m,precipitation_probability"
            + "&forecast_hours=24&timezone=auto&timeformat=unixtime&temperature_unit=celsius")
    }

    @Test func usesFahrenheitWhenRequested() {
        let request = ForecastRequest(coordinates: krakow, temperatureUnit: .fahrenheit)

        #expect(request.url(configuration: configuration).absoluteString.hasSuffix("&temperature_unit=fahrenheit"))
    }
}
