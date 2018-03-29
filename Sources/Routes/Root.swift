import Foundation
import Request

public class Root: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData {
        var body: String
        if let files = getFilesFromDirectory(directory: request.directory){
            body = prepareBody(body: files, method: request.method)
        } else {
            body = prepareBody(body: "Hello World", method: request.method)
        } 
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func getFilesFromDirectory(directory: String) -> String? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: directory).joined(separator: "\n")
        } catch {
            print("File could not be read. \(error)")
        }
        return nil 
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return ""    
        } else {
            return body 
        }
    }

    private func packResponseLine(request: Request) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = "200"
        responseLineData["statusMessage"] = "OK"
        return responseLineData
    }

    private func packResponseHeaders(body: String) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count) 
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET, HEAD, OPTIONS" 
        return headersData
    }

}
