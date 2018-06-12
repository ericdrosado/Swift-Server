import Foundation

public enum HTTPStatus: UInt {
    case ok = 200
    case created = 201
    case noContent = 204
    case partialContent = 206
    case found = 302
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAllowed = 405
    case rangeNotSatisfiable = 416
    case teapot = 418

    var descriptor : String {
        switch self {
            case .ok: return "OK"
            case .created: return "Created"
            case .noContent: return "No Content"
            case .partialContent: return "Partial Content"
            case .found: return "Found"
            case .unauthorized: return "Unauthorized"
            case .forbidden: return "Forbidden"
            case .notFound: return "Not Found" 
            case .notAllowed: return "Method Not Allowed"
            case .rangeNotSatisfiable: return "Requested Range Not Satisfiable"
            case .teapot: return "I'm a teapot"
        }
    }

    public func toStatusLine(version: String) -> String {
        return "\(version) \(self.rawValue) \(self.descriptor)"
    }
}
