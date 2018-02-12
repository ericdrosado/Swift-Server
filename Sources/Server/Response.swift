import Foundation

public class Response {

    let parser: Parser
    var paths: [String: (Response) -> (Request) -> (String)] = ["/": handleRoot,"/hello": handleHello,"/coffee": handleCoffee, "/tea": handle200]
    let status200: String
    let status404: String
    let status404Body: String

    public init(parser: Parser){
        self.parser = parser
        self.status200 = "200 OK"
        self.status404 = "404 Not Found"
        self.status404Body = "404 Page Not Found"
    }

    public func buildResponse(serverRequest: String) -> String {
        let request = parser.parseRequest(request: serverRequest)
        if (paths.keys.contains(request.path)) {
            return paths[request.path]!(self)(request)
        } else {
            return handle404(request: request)
        }
    }

    private func buildBody(request: Request) -> String {
        var queries = [String]()
        for (_, value) in request.queries {
            queries.append(value)    
        }
        return queries
                .filter({$0 != ""})
                .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
                .joined(separator: " ")
    }

    private func prepareBody(body: String, method: String) -> String {
        if (body == status404Body && method == "HEAD" || method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHeader(statusCode: String, contentLength: Int) -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }

    private func handle200(request: Request) -> String {
        let body = ""
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count) 
        return header + body
    }

    private func handle404(request: Request) -> String {
        let body = prepareBody(body: status404Body, method: request.method) 
        let header = buildHeader(statusCode: status404, contentLength: body.utf8.count) 
        return header + body
    }

    private func handleRoot(request: Request) -> String {
        var body = "Hello World"  
        body = prepareBody(body: body, method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    } 

    private func handleHello(request: Request) -> String {
        let body = prepareBody(body: "Hello \(buildBody(request: request))", method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }

    private func handleCoffee(request: Request) -> String {
        var body = "I'm a teapot"
        let header = buildHeader(statusCode: "418", contentLength: body.utf8.count)
        return header + body
    }
}


