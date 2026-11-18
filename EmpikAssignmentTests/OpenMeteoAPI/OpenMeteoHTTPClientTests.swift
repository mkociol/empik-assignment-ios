import Foundation
import Testing
@testable import EmpikAssignment

struct OpenMeteoHTTPClientTests {
    private let configuration = OpenMeteoConfiguration.example

    @Test func sendsRequestURLAndDecodesSuccessfulResponse() async throws {
        let request = CitySearchRequest(cityName: "Singapore", language: "pl")
        let expectedURL = request.url(configuration: configuration)
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            #expect(url == expectedURL)
            return (Data(RecordedGeocodingResponse.singapore.utf8), HTTPURLResponse.stub(url: url, statusCode: 200))
        })

        let response = try await client.send(request)

        #expect(response.results?.map(\.id) == [1_880_252])
    }

    @Test func throwsServerErrorWithReasonFromAPI() async {
        let request = ForecastRequest(latitude: 200, longitude: 0, temperatureUnit: .celsius)
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            (Data(invalidLatitudeResponse.utf8), HTTPURLResponse.stub(url: url, statusCode: 400))
        })

        await #expect(throws: OpenMeteoAPIError.server(reason: "Latitude must be in range of -90 to 90°. Given: 200.0.")) {
            try await client.send(request)
        }
    }

    @Test(arguments: [URLError.Code.notConnectedToInternet, .networkConnectionLost, .timedOut, .dataNotAllowed])
    func throwsOfflineWhenThereIsNoConnection(code: URLError.Code) async {
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { _ in throw URLError(code) })

        await #expect(throws: OpenMeteoAPIError.offline) {
            try await client.send(CitySearchRequest(cityName: "Kraków", language: "pl"))
        }
    }

    @Test func throwsCancellationErrorWhenRequestIsCancelled() async {
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { _ in throw URLError(.cancelled) })

        await #expect(throws: CancellationError.self) {
            try await client.send(CitySearchRequest(cityName: "Kraków", language: "pl"))
        }
    }

    /// Recorded real response: forecast for latitude 200 (HTTP 400).
    private let invalidLatitudeResponse = """
    {"error":true,"reason":"Latitude must be in range of -90 to 90°. Given: 200.0."}
    """
}
