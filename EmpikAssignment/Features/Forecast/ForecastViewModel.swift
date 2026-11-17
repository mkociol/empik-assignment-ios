import Observation

@Observable
final class ForecastViewModel {
    enum State: Equatable {
        case loading
        case loaded(Forecast)
        case failed(RemoteDataFailure)
    }

    enum Action {
        case appeared
        case retryTapped
    }

    let city: City
    private(set) var state: State = .loading

    private let forecastClient: ForecastClient

    init(city: City, forecastClient: ForecastClient) {
        self.city = city
        self.forecastClient = forecastClient
    }

    func send(_ action: Action) async {
        switch action {
        case .appeared:
            guard state == .loading else { return }
            await loadForecast()
        case .retryTapped:
            state = .loading
            await loadForecast()
        }
    }

    private func loadForecast() async {
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
