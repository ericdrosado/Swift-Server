import Foundation
import Request
import ServerIO

public class PatchContent: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> RouteData {
        var body = ""
        var responseLineData: [String: String] = [:]
        var headersData: [String: String] = [:] 
        let path = "\(request.directory)\(request.path)"
            if (request.method == "GET" ) {
                body = documentIO.readText(path: path)
                responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK") 
                headersData = packResponseHeaders(body: body) 
            } else if (request.method == "PATCH") {
                documentIO.writePlainText(text: request.body["body"]!, path: path)
                body = documentIO.readText(path: path)
                responseLineData = packResponseLine(request: request, statusCode: "204", statusMessage: "No Content") 
                headersData = packResponseHeaders(body: body) 
            } else {
                responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
                headersData = packResponseHeaders(body: body)
            }
        
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func packResponseLine(request: Request, statusCode: String, statusMessage: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = statusCode
        responseLineData["statusMessage"] = statusMessage
        return responseLineData
    }

    private func packResponseHeaders(body: String, additionalHeaders: [String: String]? = nil) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count)
        headersData["Content-Type"] = "text/plain; charset=utf-8"
        headersData["Allow"] = "GET, PATCH"
        if (additionalHeaders != nil) {
            for (key, value) in additionalHeaders! {
                headersData[key] = value
            }
        }
        return headersData
    }

}
