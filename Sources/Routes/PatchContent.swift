import Foundation
import Request

public class PatchContent: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData {
        var body = ""
        var responseLineData: [String: String] = [:]
        var headersData: [String: String] = [:] 
        if let path = NSURL.fileURL(withPathComponents: ["\(request.directory)\(request.path)"]) {
            if (request.method == "GET" ) {
                body = readText(request: request, path: path)
                responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK") 
                headersData = packResponseHeaders(body: body) 
            } else if (request.method == "PATCH") {
                writeText(request: request, path: path)
                body = readText(request: request, path: path)
                responseLineData = packResponseLine(request: request, statusCode: "204", statusMessage: "No Content") 
                headersData = packResponseHeaders(body: body) 
            } else {
                responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
                headersData = packResponseHeaders(body: body)
            }
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

    private func readText(request: Request, path: URL) -> String {
        var fileData: String = String()
        do {
            fileData = try String(contentsOf: path, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading file. \(error)")
        }
        return fileData
    }

    private func writeText(request: Request, path: URL) {
        if let text = request.body["body"] {  
            do {
                try text.write(to: path, atomically: false,
                encoding: String.Encoding.utf8)
            } catch {
                print("Error writing to file. \(error)") 
            }
        }
    }
}
