import Foundation
import Socket

class Server {
    
    private let port: Int
    private let acceptNewConnection = true
    private let greeting = "Hello World"

    init(port: Int){
        self.port = port
    }

    public func createSocket() throws{
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
        try connectedSocket.write(from:"HTTP/1.1 200 OK\r\n Content-Length: \(greeting.count) \r\n Content-type: text/html|r|n Connection: Closed\r\n\r\n <!DOCTYPE html> <html> <body>  <h1>\(greeting)</h1> </body> </html>")
        } while acceptNewConnection
        
    }
}
    
let server = Server(port: 3333)
try server.createSocket()
