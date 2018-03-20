import Foundation
import Request

public class FourOhFour {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let body = prepareBody(body: "404 Page Not Found", method: request.method) 
        let header = buildHeader(statusCode: "404 Not Found", contentLength: body.utf8.count) 
        return header + body
    }
    
    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }
    
    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }

}
