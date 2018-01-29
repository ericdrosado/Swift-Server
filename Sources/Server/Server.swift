import Foundation
import Socket

public class Server {
    
    private let port: Int
    private let acceptNewConnection = true
    static let body = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    static let header = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n"
    
    public init(port: Int){
        self.port = port
    }

    public func startServer() throws {
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            let request = try connectedSocket.readString()! 
            let httpRequest = getRequestMethod(request: request)
            let response = prepareResponse(request: httpRequest)
            try connectedSocket.write(from: response)
            connectedSocket.close()
        } while acceptNewConnection
    }

    public func getRequestMethod(request: String) -> String {
        let requestMethod = request.components(separatedBy: " ")
        return requestMethod[0]
    }

    public func prepareResponse(request: String) -> String {
        if (request == "GET") {
           return Server.header + Server.body          
        } else {
            return Server.header
        } 
    }

}

