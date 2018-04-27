import Foundation
import Request
import Response
import ServerIO

public class PatchContent: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> ResponseData {
        var body = ""
        var status = ""
        let path = "\(request.directory)\(request.path)"
            if (request.method == "GET" ) {
                body = documentIO.readText(path: path)
                status = Status.status200(version: request.httpVersion)
            } else if (request.method == "PATCH") {
                documentIO.writePlainText(text: request.body["body"]!, path: path)
                body = documentIO.readText(path: path)
                status = Status.status204(version: request.httpVersion)
            } else {
                status = Status.status405(version: request.httpVersion)
            }
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)      
    }

}
