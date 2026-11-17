import Foundation
import SwiftData
import Testing
@testable import EmpikAssignment

struct SearchHistoryRepositorySwiftDataTests {
    private let krakow = City(
        id: 3_094_802,
        name: "Kraków",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 50.06143, longitude: 19.93658)
    )
    private let lodz = City(
        id: 3_093_133,
        name: "Łódź",
        region: "Województwo łódzkie",
        coordinates: Coordinates(latitude: 51.77058, longitude: 19.47395)
    )
    private let singapore = City(
        id: 1_880_252,
        name: "Singapore",
        region: nil,
        coordinates: Coordinates(latitude: 1.28967, longitude: 103.85007)
    )

    @Test func loadsEmptyHistoryFromEmptyStore() async throws {
        let repository = try SearchHistoryRepository.swiftData(modelContainer: makeInMemoryModelContainer())

        let history = try await repository.load()

        #expect(history.cities.isEmpty)
    }

    @Test func loadsSavedCitiesInSameOrder() async throws {
        let repository = try SearchHistoryRepository.swiftData(modelContainer: makeInMemoryModelContainer())

        try await repository.save(SearchHistory(cities: [singapore, krakow, lodz]))
        let history = try await repository.load()

        #expect(history.cities == [singapore, krakow, lodz])
    }

    @Test func savingReplacesPreviousHistory() async throws {
        let modelContainer = try makeInMemoryModelContainer()
        let repository = SearchHistoryRepository.swiftData(modelContainer: modelContainer)

        try await repository.save(SearchHistory(cities: [krakow, lodz, singapore]))
        try await repository.save(SearchHistory(cities: [lodz]))
        let history = try await repository.load()

        #expect(history.cities == [lodz])
        #expect(try ModelContext(modelContainer).fetchCount(FetchDescriptor<SearchHistoryEntry>()) == 1)
    }

    @Test func keepsHistoryAfterAppRelaunch() async throws {
        let storeURL = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).store")
        defer { removeStoreFiles(at: storeURL) }

        try await saveHistory(SearchHistory(cities: [krakow, singapore]), toStoreAt: storeURL)
        let relaunchedRepository = try SearchHistoryRepository.swiftData(
            modelContainer: ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(url: storeURL))
        )
        let history = try await relaunchedRepository.load()

        #expect(history.cities == [krakow, singapore])
    }

    private func makeInMemoryModelContainer() throws -> ModelContainer {
        try ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }

    private func saveHistory(_ history: SearchHistory, toStoreAt storeURL: URL) async throws {
        let modelContainer = try ModelContainer(for: SearchHistoryEntry.self, configurations: ModelConfiguration(url: storeURL))
        try await SearchHistoryRepository.swiftData(modelContainer: modelContainer).save(history)
    }

    private func removeStoreFiles(at storeURL: URL) {
        for suffix in ["", "-shm", "-wal"] {
            try? FileManager.default.removeItem(at: URL(filePath: storeURL.path() + suffix))
        }
    }
}
