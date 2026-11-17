nonisolated struct SearchHistoryRepository {
    var load: @Sendable () async throws -> SearchHistory
    var save: @Sendable (SearchHistory) async throws -> Void
}
