extension SearchHistoryEntry {
    convenience init(city: City, position: Int) {
        self.init(
            cityID: city.id,
            name: city.name,
            region: city.region,
            latitude: city.coordinates.latitude,
            longitude: city.coordinates.longitude,
            position: position
        )
    }

    func toCity() -> City {
        City(
            id: cityID,
            name: name,
            region: region,
            coordinates: Coordinates(latitude: latitude, longitude: longitude)
        )
    }
}
