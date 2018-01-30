 import Foundation

 public class Response {

    public static let body = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    public let header404 = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nContent-type: text/html\r\n\r\n" 
    public let header200 = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n" 

    public init(){}

    public func buildResponse(serverRequest: String) -> String {
        let (requestMethod, requestPath) = parseRequest(request: serverRequest)
        let responseHeader = prepareHeader(path: requestPath)
        return  prepareResponse(method: requestMethod, header: responseHeader) 
    }

    private func parseRequest(request: String) -> (String, String) {
        let requestComponent = request.components(separatedBy: " ")
        return (requestComponent[0], requestComponent[1])
    }

    private func prepareHeader(path: String) -> String {
        if (path != "/") {
            return header404
        } else {
            return header200       
        }      
    }

    private func prepareResponse(method: String, header: String) -> String {
        if (header == header404) {
            return header 
        } else if (method == "GET") {
            return header + Response.body          
        } else {
            return header
        } 
    }
    
}

