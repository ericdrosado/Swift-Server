import Foundation
import Request
import Response

public class Redirect: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData{
        let body = "" 
        return ResponseData(statusLine: HTTPStatus.found.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Location": "/"]), 
                            body: body)      
        }

}
