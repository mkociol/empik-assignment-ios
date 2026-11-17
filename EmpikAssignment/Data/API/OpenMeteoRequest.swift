import Foundation

nonisolated protocol OpenMeteoRequest: Sendable {
    associatedtype Response: Decodable

    func url(configuration: AppConfiguration) -> URL
}
