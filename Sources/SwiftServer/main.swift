import Foundation
import Socket

class Server {
    
    private let port: Int
    private let acceptNewConnection = true
    private let greeting = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"

    init(port: Int){
        self.port = port
    }

    public func createSocket() throws{
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            try connectedSocket.write(from:"HTTP/1.1 200 OK\r\nContent-Length: \(greeting.utf8.count)\r\nContent-type: text/html\r\nConnection: close\r\n\r\n\(greeting)")
            connectedSocket.close()
        } while acceptNewConnection
        
    }
}
    
let server = Server(port: 3333)
try server.createSocket()
