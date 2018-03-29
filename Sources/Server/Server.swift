import Foundation
import Socket

public class Server {
    
    private let acceptNewConnection = true
    private let parser: Parser
    private let port: Int
    let responder: Responder
    let router: Router

    public init(parser: Parser, port: Int, responder: Responder, router: Router) {
        self.parser = parser
        self.port = port
        self.responder = responder  
        self.router = router
    }

    public func startServer() throws {
        let socket = try Socket.create()
        try socket.listen(on: port)
        repeat {
            do {
                let connectedSocket = try socket.acceptClientConnection()
                let request = try connectedSocket.readString()! 
                let parsedRequest = parser.parseRequest(request: request)
                let routeData = router.handleRoute(request: parsedRequest)
                let requestResponse = responder.buildResponse(routeData: routeData)
                try connectedSocket.write(from: requestResponse)
                connectedSocket.close()
            } catch {
                print("Error while accepting client connection. \(error)")
            }
        } while acceptNewConnection
    }

}

