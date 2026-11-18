nonisolated struct City: Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String?
    let country: String?
    let coordinates: Coordinates
}
