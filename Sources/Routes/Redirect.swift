import Foundation
import Request

public class Redirect: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData{
        let body = "" 
        let responseLineData = packResponseLine(request: request, body: body) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func packResponseLine(request: Request, body: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = "302"
        responseLineData["statusMessage"] = "Found" 
        return responseLineData
    }

    private func packResponseHeaders(body: String) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count) 
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET, HEAD, OPTIONS" 
        headersData["Location"] = "/"
        return headersData
    }

}
