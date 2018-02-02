import Foundation

public class Response {

    let parser: Parser
    var paths: Array<String>
    let status200: String
    let status404: String
    let status404Body: String

    public init(parser: Parser){
        self.parser = parser
        self.paths = ["/","/hello"]
        self.status200 = "200 OK"
        self.status404 = "404 Not Found"
        self.status404Body = "404 Page Not Found"
    }

   public func buildResponse(serverRequest: String) -> String {
        let (requestMethod, requestPath) = parser.parseRequest(request: serverRequest)
        return  prepareResponse(method: requestMethod, path: requestPath)
   }

   private func prepareResponse(method: String, path: String) -> String {
        let body: String
        let header: String
        if (paths.contains(path)) {
            body = prepareBody(body: "Hello \(buildBody())", method: method)
            header = buildHeader(statusCode: status200, contentLength: body.utf8.count) 
            parser.setDefaultQueries()
        } else {
            body = prepareBody(body: status404Body, method: method) 
            header = buildHeader(statusCode: status404, contentLength: body.utf8.count) 
        }      
        return header + body
   }

   private func buildBody() -> String {
        let querieNames = [parser.queries["fname"], parser.queries["mname"], parser.queries["lname"]] 
        return querieNames.filter({$0 != ""}).map({$0!.trimmingCharacters(in:.whitespacesAndNewlines)}).joined(separator: " ")
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

}


