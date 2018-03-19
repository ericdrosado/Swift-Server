import Foundation
import Request

public class Redirect: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let body = prepareBody(body: "Hello World", method: request.method)
        let header = "HTTP/1.1 302\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\nLocation: /\r\n\r\n" 
        return header + body
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }
}
