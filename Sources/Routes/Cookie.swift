import Foundation
import Request
import Response

public class Cookie: Route {
    
    public init(){}
    
    public func handleRoute(request: Request) -> ResponseData {
        let body = prepareBody(method: request.method)
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Set-Cookie": concatenateKeyValue(request: request) ]), 
                            body: body)
    }

    private func prepareBody(method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            return "Eat"
        }
    }

    private func concatenateKeyValue(request: Request) -> String {
        var cookie = ""
        for (key, value) in request.queries {
            cookie += "\(key) = \(value)"
        }
        return cookie
    }

}
