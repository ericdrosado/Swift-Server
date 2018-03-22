import Foundation
import Request

public class Tea: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData {
        let body = "" 
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func packResponseLine(request: Request) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = "200"
        responseLineData["statusMessage"] = "OK" 
        return responseLineData
    }

    private func packResponseHeaders(body: String) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count) 
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET, HEAD, OPTIONS" 
        return headersData
    }

}
