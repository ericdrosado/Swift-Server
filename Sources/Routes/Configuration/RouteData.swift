import Foundation

public struct RouteData {

    public let responseLine: [String: String]
    public let headers: [String: String]
    public let body: String
    public let image: [UInt8]?

    public init(responseLine: [String: String], headers: [String: String], body: String, image: [UInt8]? = nil) {
        self.responseLine = responseLine
        self.headers = headers
        self.body = body
        self.image = image
    }

}
