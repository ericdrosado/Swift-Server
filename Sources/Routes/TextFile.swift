import Foundation
import Request
import Response
import ServerIO

public class TextFile: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> ResponseData {
        let path = "\(request.directory)\(request.path)"
        var body = documentIO.readText(path: path)
        if (request.method == "HEAD") {
            body = ""
        }
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)        
    }
        
}
