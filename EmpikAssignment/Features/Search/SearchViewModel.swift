import Observation

@Observable
final class SearchViewModel {
    enum State: Equatable {
        case history
        case invalidInput(CityNameValidationError)
        case loading
        case results([City])
        case noResults(query: String)
        case failed(RemoteDataFailure)
    }

    private var query = ""
    private(set) var state: State = .history
    private(set) var history = SearchHistory()

    var canClearHistory: Bool {
        state == .history && !history.cities.isEmpty
    }

    private let citySearchClient: CitySearchClient
    private let searchHistoryRepository: SearchHistoryRepository
    private let debounceDuration: Duration
    private let sleep: @Sendable (Duration) async throws -> Void

    init(
        citySearchClient: CitySearchClient,
        searchHistoryRepository: SearchHistoryRepository,
        debounceDuration: Duration = .milliseconds(300),
        sleep: @escaping @Sendable (Duration) async throws -> Void = { try await Task.sleep(for: $0) }
    ) {
        self.citySearchClient = citySearchClient
        self.searchHistoryRepository = searchHistoryRepository
        self.debounceDuration = debounceDuration
        self.sleep = sleep
    }

    /// History is optional: the repository logs its failures and the search keeps working without it.
    func loadHistory() async {
        if let storedHistory = try? await searchHistoryRepository.load() {
            history = storedHistory
        }
    }

    func queryChanged(_ text: String) async {
        // The search field sends its text again when the list reappears; that must not repeat the search.
        guard text != query else { return }
        query = text

        let validationResult = CityNameValidator.validate(text)
        if case let .invalid(error) = validationResult {
            state = .invalidInput(error)
            return
        }
        guard text.count >= CitySearchClient.minimumCityNameLength else {
            state = .history
            return
        }
        guard validationResult == .valid else {
            return
        }
        await search(for: text, after: debounceDuration)
    }

    func retrySearch() async {
        await search(for: query, after: .zero)
    }

    func citySelected(_ city: City) async {
        history.add(city)
        await saveHistory()
    }

    func removeFromHistory(_ city: City) async {
        history.remove(city)
        await saveHistory()
    }

    func clearHistory() async {
        history.removeAll()
        await saveHistory()
    }

    private func search(for cityName: String, after delay: Duration) async {
        do {
            try await sleep(delay)
            state = .loading
            let cities = try await citySearchClient.searchCities(cityName)
            guard !Task.isCancelled else { return }
            state = cities.isEmpty ? .noResults(query: cityName) : .results(cities)
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed(RemoteDataFailure(error))
        }
    }

    private func saveHistory() async {
        try? await searchHistoryRepository.save(history)
    }
}
