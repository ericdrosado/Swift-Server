import Foundation
import Request

public class Root: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        var body: String
        if let files = getFilesFromDirectory(directory: request.directory){
            body = prepareBody(body: files, method: request.method)
        } else {
            body = prepareBody(body: "Hello World", method: request.method)
        } 
        let header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
        return header + body
    }

    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }

    private func getFilesFromDirectory(directory: String) -> String? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: directory).joined(separator: "\n")
        } catch {
            print("File could not be read. \(error)")
        }
        return nil 
    }

}
