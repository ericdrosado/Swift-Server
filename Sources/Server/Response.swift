import Foundation

public class Response {

   public var queries: [String:String] = ["noun": "World"]
   public var paths = ["/","/hello"]
   public let status200 = "200 OK"
   public let status404 = "404 Not Found"
   public let status404Body = "404 Page Not Found"

   public init(){}

   public func buildResponse(serverRequest: String) -> String {
       let (requestMethod, requestPath) = parseRequest(request: serverRequest)
       return  prepareResponse(method: requestMethod, path: requestPath)
   }

   private func prepareResponse(method: String, path: String) -> String {
       let body: String
       let header: String
       if (paths.contains(path)) {
           body = prepareBody(body: "Hello \(queries["noun"]!)", method: method)
           header = buildHeader(statusCode: status200, contentLength: body.utf8.count) 
       } else {
           body = prepareBody(body: status404Body, method: method) 
           header = buildHeader(statusCode: status404, contentLength: body.utf8.count) 
       }      
       return header + body
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

   private func parseRequest(request: String) -> (String, String) {
        let requestComponent = request.components(separatedBy: " ")
            if (requestComponent[1].contains("?")) {
                let path = parsePathForQueries(path: requestComponent[1])
                return (requestComponent[0], path) 
            }
        return (requestComponent[0], requestComponent[1])
   }

   private func parsePathForQueries(path: String) -> String {
        let parsedQueries = path.split(separator: "?") 
        let query = parsedQueries[1].split(separator: "=") 
        self.queries.updateValue(String(query[1]), forKey: String(query[0]))
        return String(parsedQueries[0])
   }

}

