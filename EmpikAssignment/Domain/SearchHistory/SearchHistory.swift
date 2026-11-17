nonisolated struct SearchHistory: Equatable {
    private(set) var cities: [City]

    init(cities: [City] = []) {
        self.cities = cities
    }

    mutating func add(_ city: City) {
        cities.removeAll { $0.id == city.id }
        cities.insert(city, at: 0)
    }

    mutating func remove(_ city: City) {
        cities.removeAll { $0.id == city.id }
    }

    mutating func removeAll() {
        cities.removeAll()
    }
}
