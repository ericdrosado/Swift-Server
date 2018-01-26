import Foundation
import Socket

public class Server {
    
    private let port: Int
    private let acceptNewConnection = true
    private let requestBody: [String: String] = ["GET": "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>", "HEAD": ""]

    public init(port: Int){
        self.port = port
    }

    public func startServer() throws{
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            let request = try connectedSocket.readString() 
            let httpRequest = parseRequest(request: request!)
            try connectedSocket.write(from: httpRequest.request)
            connectedSocket.close()
        } while acceptNewConnection
    }

    private func parseRequest(request: String) -> Request{
        let requestMethod = request.components(separatedBy: " /")
        return  Request(body: requestBody[requestMethod[0]]!)
    }

}

struct Request {

    let request: String
    
    init(body: String) {
       let body = body
       let header = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n"
       request = header + body 
    }
}
