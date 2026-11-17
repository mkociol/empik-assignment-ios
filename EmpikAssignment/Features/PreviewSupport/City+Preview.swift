#if DEBUG
extension City {
    nonisolated static let previewKrakow = City(
        id: 3_094_802,
        name: "Kraków",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 50.06143, longitude: 19.93658)
    )
    nonisolated static let previewLodz = City(
        id: 3_093_133,
        name: "Łódź",
        region: "Województwo łódzkie",
        coordinates: Coordinates(latitude: 51.77058, longitude: 19.47395)
    )
    nonisolated static let previewSingapore = City(
        id: 1_880_252,
        name: "Singapore",
        region: nil,
        coordinates: Coordinates(latitude: 1.28967, longitude: 103.85007)
    )
    nonisolated static let previewLlanfairpwll = City(
        id: 2_644_080,
        name: "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch",
        region: "Walia",
        coordinates: Coordinates(latitude: 53.22141, longitude: -4.20329)
    )
}
#endif
