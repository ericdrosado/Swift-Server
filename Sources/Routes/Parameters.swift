import Foundation
import Request

public class Parameters: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        var body = prepareBody(body: "\(buildParameterBody(request: request))", method: request.method)
        let header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
        return header + body
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
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
