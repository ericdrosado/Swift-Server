import Foundation
import Request
import Response

public class Coffee: Route {

    public init() {}

    public func handleRoute(request: Request) -> ResponseData {
        let body = prepareBody(method: request.method)
        return ResponseData(statusLine: HTTPStatus.teapot.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)
    }

    private func prepareBody(method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return "" 
        } else {
            return "I'm a teapot"
        }
    }

}
