import OSLog
import SwiftData

extension SearchHistoryRepository {
    nonisolated static func swiftData(modelContainer: ModelContainer, logger: Logger) -> SearchHistoryRepository {
        let store = SearchHistoryStore(modelContainer: modelContainer)
        return SearchHistoryRepository(
            load: {
                do {
                    return try await SearchHistory(cities: store.loadCities())
                } catch {
                    logger.error("Loading search history failed: \(String(describing: error), privacy: .public)")
                    throw error
                }
            },
            save: { history in
                do {
                    try await store.replaceCities(with: history.cities)
                } catch {
                    logger.error("Saving search history failed: \(String(describing: error), privacy: .public)")
                    throw error
                }
            }
        )
    }
}
