import Foundation
import Request

public class MethodOptions2: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let body = ""
        return buildHeader(statusCode: "200 OK", contentLength: body.utf8.count, additionalHeaders: "Allow: GET,HEAD,OPTIONS\r\n") 
    }

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }
}
