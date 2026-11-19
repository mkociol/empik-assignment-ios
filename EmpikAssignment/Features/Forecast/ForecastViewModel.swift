import Observation

@Observable
final class ForecastViewModel {
    enum State: Equatable {
        case loading
        case loaded(Forecast)
        case failed(RemoteDataFailure)
    }

    let city: City
    private(set) var state: State = .loading

    private let forecastClient: ForecastClient

    init(city: City, forecastClient: ForecastClient) {
        self.city = city
        self.forecastClient = forecastClient
    }

    func loadForecastIfNeeded() async {
        guard state == .loading else { return }
        await fetchForecast()
    }

    func retry() async {
        state = .loading
        await fetchForecast()
    }

    private func fetchForecast() async {
        do {
            let forecast = try await forecastClient.fetchForecast(city.coordinates)
            guard !Task.isCancelled else { return }
            state = .loaded(forecast)
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed(RemoteDataFailure(error))
        }
    }
}
