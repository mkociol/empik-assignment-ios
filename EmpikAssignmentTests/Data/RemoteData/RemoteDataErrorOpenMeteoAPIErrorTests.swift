import Testing
@testable import EmpikAssignment

struct RemoteDataErrorOpenMeteoAPIErrorTests {
    @Test(arguments: [
        (OpenMeteoAPIError.offline, RemoteDataError.offline),
        (
            .server(reason: "Latitude must be in range of -90 to 90°. Given: 200.0."),
            .server(reason: "Latitude must be in range of -90 to 90°. Given: 200.0.")
        ),
        (.invalidResponse, .invalidResponse)
    ])
    func translatesAPIErrorToRemoteDataError(apiError: OpenMeteoAPIError, expected: RemoteDataError) {
        #expect(RemoteDataError(apiError) == expected)
    }
}
