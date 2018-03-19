import Foundation
import Request

public class Coffee: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let body = "I'm a teapot"
        let header = buildHeader(statusCode: "418", contentLength: body.utf8.count)
        return header + body
    }
    
    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }

}
