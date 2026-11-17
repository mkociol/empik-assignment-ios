extension RemoteDataError {
    nonisolated init(_ apiError: OpenMeteoAPIError) {
        switch apiError {
        case .offline: self = .offline
        case let .server(reason): self = .server(reason: reason)
        case .invalidResponse: self = .invalidResponse
        }
    }
}
