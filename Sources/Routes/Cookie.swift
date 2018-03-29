import Foundation
import Request

public class Cookie: Route {
    
    public init(){}
    
    public func handleRoute(request: Request) -> RouteData {
        let body = prepareBody(method: request.method)
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body, request: request)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func prepareBody(method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            return "Eat"
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
        headersData["Set-Cookie"] = concatenateKeyValue(request: request)
        return headersData
    }

    private func concatenateKeyValue(request: Request) -> String {
        var cookie = ""
        for (key, value) in request.queries {
            cookie += "\(key) = \(value)"
        }
        return cookie
    }

}
