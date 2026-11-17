nonisolated struct City: Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String?
    let coordinates: Coordinates
}
