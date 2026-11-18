extension GeocodingResponseDTO {
    nonisolated func toCities() -> [City] {
        (results ?? []).map { result in
            City(
                id: result.id,
                name: result.name,
                region: result.admin1,
                country: result.country,
                coordinates: Coordinates(latitude: result.latitude, longitude: result.longitude)
            )
        }
    }
}
