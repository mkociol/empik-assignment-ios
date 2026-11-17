import Foundation

nonisolated protocol OpenMeteoRequest: Sendable {
    associatedtype Response: Decodable & Sendable

    func url(configuration: AppConfiguration) -> URL
}
