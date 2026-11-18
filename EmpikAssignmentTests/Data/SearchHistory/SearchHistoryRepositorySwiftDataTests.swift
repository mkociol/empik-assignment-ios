import Foundation
import OSLog
import SwiftData
import Testing
@testable import EmpikAssignment

/// SwiftData on iOS 17.0 mixes up stores when several containers of the same model are open at once.
@Suite(.serialized)
struct SearchHistoryRepositorySwiftDataTests {
    @Test func loadsEmptyHistoryFromEmptyStore() async throws {
        let repository = try SearchHistoryRepository.swiftData(modelContainer: makeInMemoryModelContainer(), logger: Logger(.disabled))

        let history = try await repository.load()

        #expect(history.cities.isEmpty)
    }

    @Test func loadsSavedCitiesInSameOrder() async throws {
        let repository = try SearchHistoryRepository.swiftData(modelContainer: makeInMemoryModelContainer(), logger: Logger(.disabled))

        try await repository.save(SearchHistory(cities: [.singapore, .krakow, .lodz]))
        let history = try await repository.load()

        #expect(history.cities == [.singapore, .krakow, .lodz])
    }

    @Test func savingReplacesPreviousHistory() async throws {
        let modelContainer = try makeInMemoryModelContainer()
        let repository = SearchHistoryRepository.swiftData(modelContainer: modelContainer, logger: Logger(.disabled))

        try await repository.save(SearchHistory(cities: [.krakow, .lodz, .singapore]))
        try await repository.save(SearchHistory(cities: [.lodz]))
        let history = try await repository.load()

        #expect(history.cities == [.lodz])
        #expect(try ModelContext(modelContainer).fetchCount(FetchDescriptor<SearchHistoryEntry>()) == 1)
    }

    @Test func keepsHistoryAfterAppRelaunch() async throws {
        let storeURL = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).store")
        defer { removeStoreFiles(at: storeURL) }

        try await saveHistory(SearchHistory(cities: [.krakow, .singapore]), toStoreAt: storeURL)
        let relaunchedRepository = try SearchHistoryRepository.swiftData(
            modelContainer: ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(url: storeURL)),
            logger: Logger(.disabled)
        )
        let history = try await relaunchedRepository.load()

        #expect(history.cities == [.krakow, .singapore])
    }

    private func makeInMemoryModelContainer() throws -> ModelContainer {
        try ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }

    private func saveHistory(_ history: SearchHistory, toStoreAt storeURL: URL) async throws {
        let modelContainer = try ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(url: storeURL))
        try await SearchHistoryRepository.swiftData(modelContainer: modelContainer, logger: Logger(.disabled)).save(history)
    }

    private func removeStoreFiles(at storeURL: URL) {
        for suffix in ["", "-shm", "-wal"] {
            try? FileManager.default.removeItem(at: URL(filePath: storeURL.path() + suffix))
        }
    }
}
