import Foundation
import Request

public class Response {

    typealias PathHandler = (Response) -> (Request) -> String
    var paths: [String: PathHandler] = ["/method_options2": handleOptions2] 
    let router: Router
    let status200: String
    let status404: String
    let status404Body: String

    public init(router: Router) {
        self.router = router
        self.status200 = "200 OK"
        self.status404 = "404 Not Found"
        self.status404Body = "404 Page Not Found"
    }

    public func buildResponse(request: Request) -> String {
        if (paths.keys.contains(request.path)) {
            return paths[request.path]!(self)(request)
        } else {
            return router.handleRoute(request: request)
        }
    }

    private func handleOptions2(request: Request) -> String {
        let body = ""
        return buildHeader(statusCode: status200, contentLength: body.utf8.count, additionalHeaders: "Allow: GET,HEAD,OPTIONS\r\n") 
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

    private func buildHelloBody(request: Request) -> String {
        var queries = [String()]                                                                                         
        var queryKeys = ["fname","mname", "lname"]                                                                       
        for index in 0...queryKeys.count-1 {
            for (key, value) in request.queries {                                                                        
                if (key == queryKeys[index]) {
                    queries.append(value)
                } 
            }
        }                                                                                                            
        return queries
               .filter({$0 != ""})
               .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
               .joined(separator: " ")
    }
    
}


