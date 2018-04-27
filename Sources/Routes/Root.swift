import Foundation
import Request
import Response

public class Root: Route {

    public init(){}

    public func handleRoute(request: Request) -> ResponseData {
        if (isPublicDirectory(request: request)) {
            return getDirectoryListingData(request: request)
        } else {
            return getForbiddenDirectoryRouteData(request: request) 
        }
    }

    private func isPublicDirectory(request: Request) -> Bool {
        return request.directory.lowercased().range(of: "public") != nil
    }

    private func getDirectoryListingData(request: Request) -> ResponseData {
        let files = getFilesFromDirectory(directory: request.directory) 
        let htmlBody = buildHTMLBody(files: files)
        let body = prepareBody(body: htmlBody, method: request.method)
        return ResponseData(statusLine: Status.status200(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)        
    }

    private func getForbiddenDirectoryRouteData(request: Request) -> ResponseData {
        let statusMessage = "Forbidden"
        let body = prepareBody(body: statusMessage, method: request.method)
        return ResponseData(statusLine: Status.status403(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)    
    }

    private func getFilesFromDirectory(directory: String) -> [String] {
        var files: [String] = [] 
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: directory)
        } catch {
            files = [] 
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

}
