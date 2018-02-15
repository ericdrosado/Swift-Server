import Foundation

public class Response {

    let parser: Parser
    typealias PathHandler = (Response) -> (Request) -> String
    var paths: [String: PathHandler] = ["/": handleRoot,"/hello": handleHello,"/coffee": handleCoffee, "/tea": handleRoot, "/parameters": handleParameters]
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

    private func handle404(request: Request) -> String {
        let body = prepareBody(body: status404Body, method: request.method) 
        let header = buildHeader(statusCode: status404, contentLength: body.utf8.count) 
        return header + body
    }

    private func handleRoot(request: Request) -> String {
        var body = request.path == "/" ? "Hello World": String()
        body = prepareBody(body: body, method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    } 

    private func handleHello(request: Request) -> String {
        let sortedQueries = request.sortHelloQueries(queries: request.queries)
        let helloRequest = Request(method: request.method, path: request.path, queries: sortedQueries)
        let body = prepareBody(body: "Hello \(buildBody(request: helloRequest))", method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }

    private func handleCoffee(request: Request) -> String {
        var body = "I'm a teapot"
        let header = buildHeader(statusCode: "418", contentLength: body.utf8.count)
        return header + body
    }

    private func handleParameters(request: Request) -> String {
        var body = prepareBody(body: "\(buildBody(request: request))", method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }
    
    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHeader(statusCode: String, contentLength: Int) -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }
    
    private func buildBody(request: Request) -> String {
        var queries = [String]()
        if (request.path == "/parameters") {
            for (key, value) in request.queries {
                queries.append(key + " = ")
                queries.append(value)    
            }
        } else {
            for (_, value) in request.queries {
                queries.append(value)    
            }
        }
        return queries
                .filter({$0 != ""})
                .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
                .joined(separator: " ")
    }
}


