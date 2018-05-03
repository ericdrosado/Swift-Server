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
        let path = "\(request.directory)\(request.path)"
        var body = documentIO.readText(path: path)
        var status = "" 
            if (request.method == "HEAD" ) {
                body = ""
                status = Status.status200(version: request.httpVersion)
            } else if (request.method == "PATCH") {
                documentIO.writePlainText(text: request.body["body"]!, path: path)
                status = Status.status204(version: request.httpVersion)
            } else {
                status = Status.status200(version: request.httpVersion)
            }
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)      
    }

}
