nonisolated enum OpenMeteoAPIError: Error, Equatable {
    case offline
    case server(reason: String)
    case invalidResponse
}
