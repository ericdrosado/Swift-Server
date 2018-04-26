import Foundation
import Request
import ServerIO

public class File1: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> RouteData {
        let path = "\(request.directory)/file1"
        var body = documentIO.readText(path: path)
        var responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK")
        if (request.method != "GET") {
            body = ""
            responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
        }
        let headersData = packResponseHeaders(body: body) 
        return RouteData(responseLine: responseLineData, headers: headersData, body: body) 
    }

    private func packResponseLine(request: Request, statusCode: String, statusMessage: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = statusCode
        responseLineData["statusMessage"] = statusMessage
        return responseLineData
    }

    private func packResponseHeaders(body: String) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count)
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET"
        return headersData
    }

}
