import SwiftData

extension SearchHistoryRepository {
    nonisolated static func swiftData(modelContainer: ModelContainer) -> SearchHistoryRepository {
        let store = SearchHistoryStore(modelContainer: modelContainer)
        return SearchHistoryRepository(
            load: { try await SearchHistory(cities: store.loadCities()) },
            save: { history in try await store.replaceCities(with: history.cities) }
        )
    }
}
