import Foundation

public struct Status {

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

    public static func status403(version: String) -> String {
        return "\(version) 403 Forbidden"
    }

    public static func status404(version: String) -> String {
        return "\(version) 404 Not Found"
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

public enum HTTPStatus: UInt {
    case ok = 200
    case created = 201
    case unauthorized = 401
    case notFound = 404
    case teapot = 418

    var descriptor : String {
        switch self {
            case .ok: return "OK"
            case .created: return "Created"
            case .unauthorized: return "Unauthorized"
            case .notFound: return "Not Found" 
            case .teapot: return "I'm a teapot"
        }
    }

    public func toStatusLine(version: String) -> String {
        return "\(version) \(self.rawValue) \(self.descriptor)"
    }
}
