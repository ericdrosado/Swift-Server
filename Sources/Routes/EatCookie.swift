import Foundation
import Request
import Response

public class EatCookie: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData{
        let body = prepareBody(method: request.method, request: request)
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)    }

    private func prepareBody(method: String, request: Request) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            if let cookie = request.cookie["type"] {
                return "mmmm \(cookie)"
            }
            return ""
        }
    }

}
