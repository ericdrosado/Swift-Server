import Foundation
import Socket

public class Server {
    
    private let acceptNewConnection = true
    private let parser: Parser
    private let port: Int
    let response: Response

    public init(parser: Parser, port: Int, response: Response) {
        self.parser = parser
        self.port = port
        self.response = response  
    }

    public func startServer() throws {
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            let request = try connectedSocket.readString()! 
            let parsedRequest = parser.parseRequest(request: request)
            let requestResponse = response.buildResponse(request: parsedRequest)
            try connectedSocket.write(from: requestResponse)
            connectedSocket.close()
        } while acceptNewConnection
    }

}

