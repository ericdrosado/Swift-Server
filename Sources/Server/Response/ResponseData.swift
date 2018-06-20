import Foundation

public struct ResponseData {

    public let statusLine: String
    public let headers: [String: String]
    public let body: String
    public let image: [UInt8]?

    public init(statusLine: String, headers: [String: String], body: String, image: [UInt8]? = nil) {
        self.statusLine = statusLine
        self.headers = headers
        self.body = body
        self.image = image
    }

}