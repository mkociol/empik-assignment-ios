import Foundation
import Testing
@testable import EmpikAssignment

struct ForecastViewModelTests {
    private let krakow = City(
        id: 3_094_802,
        name: "Kraków",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 50.06143, longitude: 19.93658)
    )

    /// Values from a recorded real response for Kraków (forecast_hours=3).
    private let krakowForecast = Forecast(
        current: CurrentWeather(
            temperature: Measurement(value: 5.7, unit: .celsius),
            cloudCoverPercent: 100,
            precipitationProbabilityPercent: 85
        ),
        hourly: [
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
        ],
        timeZone: TimeZone(identifier: "Europe/Warsaw")!
    )

    @Test func appearingLoadsForecastForCityCoordinates() async {
        let requestedCoordinates = CallRecorder<Coordinates>()
        let viewModel = makeViewModel(fetchForecast: { [krakowForecast] coordinates in
            await requestedCoordinates.record(coordinates)
            return krakowForecast
        })

        await viewModel.send(.appeared)

        #expect(viewModel.state == .loaded(krakowForecast))
        #expect(await requestedCoordinates.values == [krakow.coordinates])
    }

    @Test func missingConnectionShowsOffline() async {
        let viewModel = makeViewModel(fetchForecast: { _ in throw RemoteDataError.offline })

        await viewModel.send(.appeared)

        #expect(viewModel.state == .failed(.offline))
    }

    @Test func serverErrorShowsReasonFromAPI() async {
        let reason = "Latitude must be in range of -90 to 90°. Given: 200.0."
        let viewModel = makeViewModel(fetchForecast: { _ in throw RemoteDataError.server(reason: reason) })

        await viewModel.send(.appeared)

        #expect(viewModel.state == .failed(.error(reason: reason)))
    }

    @Test func invalidResponseShowsErrorWithoutReason() async {
        let viewModel = makeViewModel(fetchForecast: { _ in throw RemoteDataError.invalidResponse })

        await viewModel.send(.appeared)

        #expect(viewModel.state == .failed(.error(reason: nil)))
    }

    @Test func retryAfterErrorLoadsForecast() async {
        let requestedCoordinates = CallRecorder<Coordinates>()
        let viewModel = makeViewModel(fetchForecast: { [krakowForecast] coordinates in
            await requestedCoordinates.record(coordinates)
            guard await requestedCoordinates.values.count > 1 else { throw RemoteDataError.offline }
            return krakowForecast
        })
        await viewModel.send(.appeared)

        await viewModel.send(.retryTapped)

        #expect(viewModel.state == .loaded(krakowForecast))
    }

    @Test func appearingAgainDoesNotReloadLoadedForecast() async {
        let requestedCoordinates = CallRecorder<Coordinates>()
        let viewModel = makeViewModel(fetchForecast: { [krakowForecast] coordinates in
            await requestedCoordinates.record(coordinates)
            return krakowForecast
        })
        await viewModel.send(.appeared)

        await viewModel.send(.appeared)

        #expect(await requestedCoordinates.values.count == 1)
    }

    @Test func loadingCancelledByLeavingScreenIsRepeatedOnNextAppearance() async {
        let requestedCoordinates = CallRecorder<Coordinates>()
        let viewModel = makeViewModel(fetchForecast: { [krakowForecast] coordinates in
            await requestedCoordinates.record(coordinates)
            guard await requestedCoordinates.values.count > 1 else { throw CancellationError() }
            return krakowForecast
        })
        await viewModel.send(.appeared)
        #expect(viewModel.state == .loading)

        await viewModel.send(.appeared)

        #expect(viewModel.state == .loaded(krakowForecast))
    }

    private func makeViewModel(
        fetchForecast: @escaping @Sendable (Coordinates) async throws -> Forecast
    ) -> ForecastViewModel {
        ForecastViewModel(city: krakow, forecastClient: ForecastClient(fetchForecast: fetchForecast))
    }
}
