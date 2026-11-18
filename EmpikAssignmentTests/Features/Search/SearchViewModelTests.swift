import Testing
@testable import EmpikAssignment

struct SearchViewModelTests {
    // MARK: - History

    @Test func appearingLoadsHistory() async {
        let storedHistory = SearchHistory(cities: [.krakow, .lodz])
        let viewModel = makeViewModel(loadHistory: { storedHistory })

        await viewModel.send(.appeared)

        #expect(viewModel.history == storedHistory)
    }

    @Test func selectingCityPutsItFirstInHistoryAndSavesIt() async {
        let savedHistories = CallRecorder<SearchHistory>()
        let viewModel = makeViewModel(
            loadHistory: { SearchHistory(cities: [.lodz]) },
            saveHistory: { await savedHistories.record($0) }
        )
        await viewModel.send(.appeared)

        await viewModel.send(.citySelected(.krakow))

        #expect(viewModel.history.cities == [.krakow, .lodz])
        #expect(await savedHistories.values == [SearchHistory(cities: [.krakow, .lodz])])
    }

    @Test func deletingCityFromHistorySavesIt() async {
        let savedHistories = CallRecorder<SearchHistory>()
        let viewModel = makeViewModel(
            loadHistory: { SearchHistory(cities: [.krakow, .lodz]) },
            saveHistory: { await savedHistories.record($0) }
        )
        await viewModel.send(.appeared)

        await viewModel.send(.historyCityDeleted(.krakow))

        #expect(viewModel.history.cities == [.lodz])
        #expect(await savedHistories.values == [SearchHistory(cities: [.lodz])])
    }

    @Test func clearingHistorySavesEmptyHistory() async {
        let savedHistories = CallRecorder<SearchHistory>()
        let viewModel = makeViewModel(
            loadHistory: { SearchHistory(cities: [.krakow, .lodz]) },
            saveHistory: { await savedHistories.record($0) }
        )
        await viewModel.send(.appeared)

        await viewModel.send(.clearHistoryConfirmed)

        #expect(viewModel.history.cities.isEmpty)
        #expect(await savedHistories.values == [SearchHistory()])
    }

    // MARK: - Query

    @Test(arguments: ["", "K"])
    func shortQueryShowsHistoryWithoutSearching(query: String) async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { await searchedNames.record($0); return [] })

        await viewModel.send(.queryChanged(query))

        #expect(viewModel.state == .history)
        #expect(await searchedNames.values.isEmpty)
    }

    @Test func invalidQueryShowsValidationErrorWithoutSearching() async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { await searchedNames.record($0); return [] })

        await viewModel.send(.queryChanged("Kraków2"))

        #expect(viewModel.state == .invalidInput(.containsDigits))
        #expect(await searchedNames.values.isEmpty)
    }

    @Test func incompleteQueryKeepsCurrentStateWithoutSearching() async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { name in
            await searchedNames.record(name)
            return [.krakow]
        })
        await viewModel.send(.queryChanged("Nowy"))

        await viewModel.send(.queryChanged("Nowy "))

        #expect(viewModel.state == .results([.krakow]))
        #expect(await searchedNames.values == ["Nowy"])
    }

    @Test func unchangedQueryKeepsResultsWithoutSearchingAgain() async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { name in
            await searchedNames.record(name)
            return [.krakow]
        })
        await viewModel.send(.queryChanged("Kraków"))

        await viewModel.send(.queryChanged("Kraków"))

        #expect(viewModel.state == .results([.krakow]))
        #expect(await searchedNames.values == ["Kraków"])
    }

    // MARK: - Search results

    @Test func validQueryShowsFoundCities() async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { name in
            await searchedNames.record(name)
            return [.krakow]
        })

        await viewModel.send(.queryChanged("Kraków"))

        #expect(viewModel.state == .results([.krakow]))
        #expect(await searchedNames.values == ["Kraków"])
    }

    @Test func queryWithoutResultsShowsNoResults() async {
        let viewModel = makeViewModel(searchCities: { _ in [] })

        await viewModel.send(.queryChanged("Xyzqwv"))

        #expect(viewModel.state == .noResults(query: "Xyzqwv"))
    }

    @Test func missingConnectionShowsOffline() async {
        let viewModel = makeViewModel(searchCities: { _ in throw RemoteDataError.offline })

        await viewModel.send(.queryChanged("Kraków"))

        #expect(viewModel.state == .failed(.offline))
    }

    @Test func serverErrorShowsReasonFromAPI() async {
        let reason = "Parameter count must be between 1 and 100."
        let viewModel = makeViewModel(searchCities: { _ in throw RemoteDataError.server(reason: reason) })

        await viewModel.send(.queryChanged("Kraków"))

        #expect(viewModel.state == .failed(.error(reason: reason)))
    }

    @Test func retryRepeatsSearchForCurrentQuery() async {
        let searchedNames = CallRecorder<String>()
        let viewModel = makeViewModel(searchCities: { name in
            await searchedNames.record(name)
            return [.krakow]
        })
        await viewModel.send(.queryChanged("Kraków"))

        await viewModel.send(.retryTapped)

        #expect(await searchedNames.values == ["Kraków", "Kraków"])
    }

    @Test func cancelledSearchSendsNoRequestAndKeepsNewerResults() async {
        let searchedNames = CallRecorder<String>()
        let debounce = HeldFirstDebounce()
        let viewModel = makeViewModel(
            searchCities: { name in
                await searchedNames.record(name)
                return name == "Łódź" ? [.lodz] : [.krakow]
            },
            sleep: { _ in try await debounce.wait() }
        )

        let typingKrakow = Task { await viewModel.send(.queryChanged("Kraków")) }
        await debounce.untilFirstWaitStarts()
        typingKrakow.cancel()
        await viewModel.send(.queryChanged("Łódź"))
        await debounce.endFirstWait()
        await typingKrakow.value

        #expect(viewModel.state == .results([.lodz]))
        #expect(await searchedNames.values == ["Łódź"])
    }

    // MARK: - Helpers

    private func makeViewModel(
        searchCities: @escaping @Sendable (String) async throws -> [City] = { _ in [] },
        loadHistory: @escaping @Sendable () async throws -> SearchHistory = { SearchHistory() },
        saveHistory: @escaping @Sendable (SearchHistory) async throws -> Void = { _ in },
        sleep: @escaping @Sendable (Duration) async throws -> Void = { _ in }
    ) -> SearchViewModel {
        SearchViewModel(
            citySearchClient: CitySearchClient(searchCities: searchCities),
            searchHistoryRepository: SearchHistoryRepository(load: loadHistory, save: saveHistory),
            sleep: sleep
        )
    }
}
