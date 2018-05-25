import Foundation

public class Headers {

    var headers: [String: String]

    public init() {
        self.headers = [:]
    }

    public func getHeaders(body: String, route: String, additionalHeaders: [String: String]? = nil) -> [String: String] {
        if (route.range(of: "image") == nil) {
            headers["Content-Length"] = String(body.utf8.count)
        }
        headers["Content-Type"] = "\(ContentType().getType(route: route))"
        if (additionalHeaders != nil) {
            for (key, value) in additionalHeaders! {
               headers[key] = value
            }
        }
        return headers
    }

}

public class ContentType {

    let contentType: [String: String]

    public init() {
        self.contentType = ["gif": "image/gif", 
                            "jpeg": "image/jpeg",
                            "png": "image/png",
                            "txt": "text/plain; charset=utf-8",
                            "html": "text/html; charset=utf-8",
                            "ico": "image/x-icon",
                            "json": "application/json"]
    }

    public func getType(route: String) -> String {
        if (route.index(of: ".") != nil) {
            let routeComponent = route.components(separatedBy: ".")
            return contentType[routeComponent[1]]!
        } else {
            return contentType["html"]!
        }
    }
}

