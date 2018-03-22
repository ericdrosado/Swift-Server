import Foundation
import Request

public class Parameters: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData{
        let body = prepareBody(request: request)
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func prepareBody(request: Request) -> String {
        if (request.method == "HEAD" || request.method == "OPTIONS") {
            return "" 
        } else {
            return buildParameterBody(request: request) 
        }
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

    private func buildParameterBody(request: Request) -> String {
         var queries = [String]()
         for (key, value) in request.queries {
             queries.append(key + " = ")
             queries.append(value)    
         }
         return queries
                .filter({$0 != ""})
                .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
                .joined(separator: " ")
    }
}
