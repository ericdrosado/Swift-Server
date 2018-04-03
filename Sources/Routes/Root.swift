import Foundation
import Request

public class Root: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData {
        if (isPublicDirectory(request: request)) {
            return getDirectoryListingData(request: request)
        } else {
            return getForbiddenDirectoryRouteData(request: request) 
        }
    }

    private func isPublicDirectory(request: Request) -> Bool {
        return request.directory.lowercased().range(of: "public") != nil
    }

    private func getDirectoryListingData(request: Request) -> RouteData {
        var body: String = ""
        if let files = getFilesFromDirectory(directory: request.directory) {
            let htmlBody = buildHTMLBody(files: files)
            body = prepareBody(body: htmlBody, method: request.method)
        } 
        let responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK") 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func getForbiddenDirectoryRouteData(request: Request) -> RouteData {
        let statusMessage = "Forbidden"
        let body = prepareBody(body: statusMessage, method: request.method)
        let responseLineData = packResponseLine(request: request, statusCode: "403", statusMessage: statusMessage) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func getFilesFromDirectory(directory: String) -> [String]? {
        var files: [String]? = [] 
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: directory)
        } catch {
            files = nil
        }
        return files 
    }

    private func buildHTMLBody(files: [String]) -> String {
        var directoryList = ""
        for file in files {
            directoryList += "<li><a href=\"/\(file)\">\(file)</li>"
        } 
        return "<DOCTYPE! html><html><body><h1>Directory Listing</h1><ul>\(directoryList)</ul></body></html>"
        
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return ""    
        } else {
            return body
        }
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
        headersData["Content-Type"] = "text/html; charset=utf-8"
        headersData["Allow"] = "GET, HEAD, OPTIONS" 
        return headersData
    }

}
