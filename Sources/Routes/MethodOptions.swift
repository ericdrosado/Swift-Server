import Foundation
import Request
import Response

public class MethodOptions: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData{
        let body = ""
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Allow": "GET,HEAD,POST,OPTIONS,PUT"]), 
                            body: body)   
    }
    
}
