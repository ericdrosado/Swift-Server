import Foundation
import Request
import Response

public class Parameters: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData{
        let body = prepareBody(request: request)
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)         
    }

    private func prepareBody(request: Request) -> String {
        if (request.method == "HEAD" || request.method == "OPTIONS") {
            return "" 
        } else {
            return buildParameterBody(request: request) 
        }
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
