import Foundation
import Request

public class Cookie: Route {
    
    public init(){}

    public func handleRoute(request: Request) -> String {
        let body = "Eat"
        let header = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\nSet-Cookie: type=chocolate\r\n\r\n" 
        return header + body
    }
}
