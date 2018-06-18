import Foundation
import Server

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
        var body = prepareBody(body: htmlBody, method: request.method)
        if (request.headers.keys.contains("Accept") && request.headers["Accept"] == "application/json") {
            body = JSONBuilder().getJSONDirectoryListing(files: files)    
            return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Content-Type": "application/json"]), 
                            body: body)        
        }
        return ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)        
    }

    private func getForbiddenDirectoryRouteData(request: Request) -> ResponseData {
        let statusMessage = "Forbidden"
        let body = prepareBody(body: statusMessage, method: request.method)
        return ResponseData(statusLine: HTTPStatus.forbidden.toStatusLine(version: request.httpVersion), 
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
        return "<!DOCTYPE html><html><body><h1>Directory Listing</h1><ul>\(directoryList)</ul></body></html>"
        
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD" || method == "OPTIONS") {
            return ""    
        } else {
            return body
        }
    }

}

public class JSONBuilder {

    public init(){}

    public func getJSONDirectoryListing(files: [String]) -> String {
        var jsonObject: [[String: String]] = []
        var jsonData = Data()
        for file in files {
            jsonObject.append(["name": file])            
        } 
        do {
            try jsonData = JSONSerialization.data(withJSONObject: jsonObject)
        } catch {
            print("Error during JSON data serialization: \(error)")
        }
        return String(data: jsonData, encoding: .utf8)!
    } 
}
