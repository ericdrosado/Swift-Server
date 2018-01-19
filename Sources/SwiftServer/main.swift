import Foundation
import Socket

class Server {
    
    private let port: Int
    private let acceptNewConnection = true

    init(port: Int){
        self.port = port
    }

    public func createSocket() throws{
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            try connectedSocket.write(from: "Hello World\n")
        } while acceptNewConnection
        
    }
}
    
let server = Server(port: 3333)
try server.createSocket()
