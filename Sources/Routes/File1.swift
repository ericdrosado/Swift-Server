import Foundation
import Request
import ServerIO
import Response

public class File1: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> ResponseData {
        let path = "\(request.directory)\(request.path)"
        var body = documentIO.readText(path: path)
        let status = HTTPStatus.ok.toStatusLine(version: request.httpVersion)
        if (request.method == "HEAD") {
            body = ""
        }
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)    
    }

}
