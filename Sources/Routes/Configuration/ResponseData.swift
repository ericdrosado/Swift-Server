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

    public static func status200(version: String) -> String {
        return "\(version) 200 OK"
    }

    public static func status201(version: String) -> String {
        return "\(version) 201 Created"
    }

    public static func status204(version: String) -> String {
        return "\(version) 204 No Content"
    }

    public static func status206(version: String) -> String {
        return "\(version) 206 Partial Content"
    }

    public static func status302(version: String) -> String {
        return "\(version) 302 Found"
    }

    public static func status401(version: String) -> String {
        return "\(version) 401 Unauthorized"
    }

    public static func status405(version: String) -> String {
        return "\(version) 405 Method Not Allowed"
    }

    public static func status416(version: String) -> String {
        return "\(version) 416 Requested Range Not Satisfiable"
    }

    public static func status418(version: String) -> String {
        return "\(version) 418 I'm a teapot"
    }

}