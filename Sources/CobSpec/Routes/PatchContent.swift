import Foundation
import Server

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
                status = HTTPStatus.ok.toStatusLine(version: request.httpVersion)
            } else if (request.method == "PATCH") {
                documentIO.writePlainText(text: request.body["body"]!, path: path)
                status = HTTPStatus.noContent.toStatusLine(version: request.httpVersion)
            } else {
                status = HTTPStatus.ok.toStatusLine(version: request.httpVersion)
            }
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)      
    }

}
