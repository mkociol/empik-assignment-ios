import SwiftData

@Model
final nonisolated class SearchHistoryEntry {
    var cityID: Int
    var name: String
    var region: String?
    var country: String?
    var latitude: Double
    var longitude: Double
    var position: Int

    init(cityID: Int, name: String, region: String?, country: String?, latitude: Double, longitude: Double, position: Int) {
        self.cityID = cityID
        self.name = name
        self.region = region
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.position = position
    }
}
