import Foundation
import Request

public class FourOhFour {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let filePath = NSURL.fileURL(withPathComponents: ["requestLog.txt"])
        let logData = readLogRequest(path: filePath!)
        writeLogRequest(request: request, loggedRequests: logData, path: filePath!) 
        let body = prepareBody(body: "404 Page Not Found", method: request.method) 
        let header = buildHeader(statusCode: "404 Not Found", contentLength: body.utf8.count) 
        return header + body
    }

    private func readLogRequest(path: URL) -> String {
        var logData: String = String()
        do {
            logData = try String(contentsOf: path, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading requestLog.txt. \(error)")
        }
        return logData
    }

    private func writeLogRequest(request: Request, loggedRequests: String, path: URL) {
        let text = "\(request.method) \(request.path) \(request.http)\n\(loggedRequests)"
        do {
            try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to requestLog.txt. \(error)")
        }
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

}
