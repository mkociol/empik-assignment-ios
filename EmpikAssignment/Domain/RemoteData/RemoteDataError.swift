nonisolated enum RemoteDataError: Error, Equatable {
    case offline
    case server(reason: String)
    case invalidResponse
}
