import Foundation

public struct RouteData {

    public let responseLine: [String: String]
    public let headers: [String: String]
    public let body: String

    public init(responseLine: [String: String], headers: [String: String], body: String) {
        self.responseLine = responseLine
        self.headers = headers
        self.body = body
    }

}
