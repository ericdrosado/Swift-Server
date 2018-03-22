import Foundation
import Request

public class EatCookie: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData{
        let body = prepareBody(method: request.method, request: request)
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body, request: request)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func prepareBody(method: String, request: Request) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            if let cookie = request.cookie {
                return "mmmm \(cookie)"
            }
            return ""
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

}
