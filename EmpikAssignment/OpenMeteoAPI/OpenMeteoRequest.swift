import Foundation

nonisolated protocol OpenMeteoRequest: Sendable {
    associatedtype Response: Decodable & Sendable

    func url(configuration: OpenMeteoConfiguration) -> URL
}
