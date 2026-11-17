import Testing
@testable import EmpikAssignment

struct RemoteDataFailureTests {
    @Test func missingConnectionIsOffline() {
        #expect(RemoteDataFailure(RemoteDataError.offline) == .offline)
    }

    @Test func serverErrorKeepsReasonFromAPI() {
        let reason = "Latitude must be in range of -90 to 90°. Given: 200.0."

        #expect(RemoteDataFailure(RemoteDataError.server(reason: reason)) == .error(reason: reason))
    }

    @Test func invalidResponseIsErrorWithoutReason() {
        #expect(RemoteDataFailure(RemoteDataError.invalidResponse) == .error(reason: nil))
    }
}
