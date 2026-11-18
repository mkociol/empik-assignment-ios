@testable import EmpikAssignment

nonisolated extension City {
    static let krakow = City(
        id: 3_094_802,
        name: "Kraków",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 50.06143, longitude: 19.93658)
    )
    static let lodz = City(
        id: 3_093_133,
        name: "Łódź",
        region: "Województwo łódzkie",
        coordinates: Coordinates(latitude: 51.77058, longitude: 19.47395)
    )
    static let nowySacz = City(
        id: 763_534,
        name: "Nowy Sącz",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 49.62177, longitude: 20.69705)
    )
    static let singapore = City(
        id: 1_880_252,
        name: "Singapore",
        region: nil,
        coordinates: Coordinates(latitude: 1.28967, longitude: 103.85007)
    )
}
