import Foundation
import Request

public class Hello: Route {
    
    public init() {}

    public func handleRoute(request: Request) -> String {
        let defaultText = "World"
        let body = prepareBody(body: "Hello \(buildHelloBody(request: request) ?? defaultText)", method: request.method)
        let header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
        return header + body
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHelloBody(request: Request) -> String? {
        var queries = [String()]                                                                                         
        var queryKeys = ["fname","mname", "lname"]                                                                       
        for index in 0...queryKeys.count-1 {
            for (key, value) in request.queries {                                                                        
                if (key == queryKeys[index]) {
                    queries.append(value)
                } 
            }
        }  
        var queryString: String?
        queryString = queries
                .filter({$0 != ""})
                .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
                .joined(separator: " ")
        if queryString == "" { queryString = nil }
        return queryString
    }

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }
}
