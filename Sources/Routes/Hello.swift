import Foundation
import Request

public class Hello: Route {
    
    public init() {}

    public func handleRoute(request: Request) -> RouteData {
        let defaultText = "World"
        let body = prepareBody(method: request.method, body: "Hello \(buildHelloBody(request: request) ?? defaultText)")
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body, request: request)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func prepareBody(method: String, body: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            return body
        }
    }

    private func packResponseLine(request: Request) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = "200"
        responseLineData["statusMessage"] = "OK"
        return responseLineData
    }

    private func packResponseHeaders(body: String, request: Request) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count) 
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET, HEAD, OPTIONS" 
        return headersData
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
