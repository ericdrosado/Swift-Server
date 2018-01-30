import Foundation
import Socket

public class Server {
    
    private let acceptNewConnection = true
    private let port: Int
    let response: Response

    public init(port: Int, response: Response) {
        self.port = port
        self.response = response  
    }

    public func startServer() throws {
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            let request = try connectedSocket.readString()! 
            let requestResponse = response.buildResponse(serverRequest: request)
            try connectedSocket.write(from: requestResponse)
            connectedSocket.close()
        } while acceptNewConnection
    }

}

