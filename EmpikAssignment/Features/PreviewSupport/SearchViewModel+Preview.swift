#if DEBUG
extension SearchViewModel {
    static func preview() -> SearchViewModel {
        SearchViewModel(
            citySearchClient: CitySearchClient(searchCities: { _ in [.previewKrakow, .previewLodz] }),
            searchHistoryRepository: SearchHistoryRepository(
                load: { SearchHistory(cities: [.previewSingapore, .previewKrakow]) },
                save: { _ in }
            )
        )
    }
}
#endif
