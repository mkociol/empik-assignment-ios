import Foundation
import Testing
@testable import EmpikAssignment

struct OpenMeteoHTTPClientTests {
    private let configuration = AppConfiguration(
        geocodingAPIBaseURL: URL(string: "https://geocoding.example.com/v1")!,
        forecastAPIBaseURL: URL(string: "https://forecast.example.com/v1")!
    )

    @Test func sendsRequestURLAndDecodesSuccessfulResponse() async throws {
        let request = CitySearchRequest(cityName: "Singapore", language: "pl")
        let expectedURL = request.url(configuration: configuration)
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            #expect(url == expectedURL)
            return (Data(singaporeResponse.utf8), httpResponse(for: url, statusCode: 200))
        })

        let response = try await client.send(request)

        #expect(response.results?.map(\.id) == [1_880_252])
    }

    @Test func throwsServerErrorWithReasonFromAPI() async {
        let request = ForecastRequest(coordinates: Coordinates(latitude: 200, longitude: 0), temperatureUnit: .celsius)
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            (Data(invalidLatitudeResponse.utf8), httpResponse(for: url, statusCode: 400))
        })

        await #expect(throws: RemoteDataError.server(reason: "Latitude must be in range of -90 to 90°. Given: 200.0.")) {
            try await client.send(request)
        }
    }

    @Test(arguments: [URLError.Code.notConnectedToInternet, .networkConnectionLost, .timedOut, .dataNotAllowed])
    func throwsOfflineWhenThereIsNoConnection(code: URLError.Code) async {
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { _ in throw URLError(code) })

        await #expect(throws: RemoteDataError.offline) {
            try await client.send(CitySearchRequest(cityName: "Kraków", language: "pl"))
        }
    }

    @Test func throwsCancellationErrorWhenRequestIsCancelled() async {
        let client = OpenMeteoHTTPClient(configuration: configuration, fetchData: { _ in throw URLError(.cancelled) })

        await #expect(throws: CancellationError.self) {
            try await client.send(CitySearchRequest(cityName: "Kraków", language: "pl"))
        }
    }

    /// Recorded real responses: city search for "Singapore" (HTTP 200) and forecast for latitude 200 (HTTP 400).
    private let singaporeResponse = """
    {"results":[{"id":1880252,"name":"Singapore","latitude":1.28967,"longitude":103.85007,"elevation":23.0,\
    "feature_code":"PPLC","country_code":"SG","timezone":"Asia/Singapore","population":5638700,\
    "country_id":1880251,"country":"Singapur"}],"generationtime_ms":0.11539459}
    """

    private let invalidLatitudeResponse = """
    {"error":true,"reason":"Latitude must be in range of -90 to 90°. Given: 200.0."}
    """
}

private nonisolated func httpResponse(for url: URL, statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
