import Foundation
import Request

public class File1: Route {

    let fileIO: FileIO

    public init(fileIO: FileIO) {
        self.fileIO = fileIO
    }

    public func handleRoute(request: Request) -> RouteData {
        let path = "\(request.directory)/file1"
        var body = fileIO.readText(path: path)
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
