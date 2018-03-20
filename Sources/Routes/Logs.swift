import Foundation
import Request

public class Logs: Route {

    let userName: String
    let password: String
    let authenticationHeader: String

    public init(){
        self.userName = "admin"
        self.password = "hunter2"
        self.authenticationHeader = "WWW-Authenticate: Basic realm= Access to logs"
    }

    public func handleRoute(request: Request) -> String {
        var body = String()
        var header = buildHeader(statusCode: "401", contentLength: body.utf8.count, additionalHeaders: authenticationHeader)
        let filePath = NSURL.fileURL(withPathComponents: ["requestLog.txt"])
        if (request.headers.keys.contains("Authorization")) {
            if (checkAuthorization(authorization: request.headers["Authorization"]!)) {
                body = readLogRequest(path: filePath!)
                header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
            }
        }
        return header + body
    }

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
            return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
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

    private func clearLog(path: URL) {
        let text = ""
        do {
            try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("Error clearing requestLog.txt. \(error)")
        }
    }

    private func checkAuthorization(authorization: String) -> Bool {
        let credentials = decodeBasicAuthorization(authorization: authorization) 
        return credentials[0] == userName && credentials[1] == password
    }

    private func decodeBasicAuthorization(authorization: String) -> Array<String> {
        let codedCredentials = authorization.components(separatedBy: " ")
        let decodedData = Data(base64Encoded: codedCredentials[2])! 
        let decodedString = String(data: decodedData, encoding: .utf8)!
        return decodedString.components(separatedBy:":") 
    }

}
