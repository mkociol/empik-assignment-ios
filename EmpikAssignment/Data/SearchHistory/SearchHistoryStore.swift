import Foundation
import SwiftData

@ModelActor
actor SearchHistoryStore {
    func loadCities() throws -> [City] {
        let entriesInOrder = FetchDescriptor<SearchHistoryEntry>(sortBy: [SortDescriptor(\.position)])
        return try modelContext.fetch(entriesInOrder).map { $0.toCity() }
    }

    func replaceCities(with cities: [City]) throws {
        for entry in try modelContext.fetch(FetchDescriptor<SearchHistoryEntry>()) {
            modelContext.delete(entry)
        }
        for (position, city) in cities.enumerated() {
            modelContext.insert(SearchHistoryEntry(city: city, position: position))
        }
        try modelContext.save()
    }
}
