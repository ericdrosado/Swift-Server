import Foundation
import Server

public class Tea: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData {
        let body = "" 
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)        }

}
