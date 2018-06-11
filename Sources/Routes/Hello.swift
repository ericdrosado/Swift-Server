import Foundation
import Request
import Response

public class Hello: Route {
    
    public init() {}

    public func handleRoute(request: Request) -> ResponseData {
        let defaultText = "World"
        let body = prepareBody(method: request.method, body: "Hello \(buildHelloBody(request: request) ?? defaultText)")
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)    
    }

    private func prepareBody(method: String, body: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            return body
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

}
