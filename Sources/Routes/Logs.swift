import Foundation
import Request

public class Logs: Route {

    let userName: String
    let password: String
    let authentication: String

    public init(){
        self.userName = "admin"
        self.password = "hunter2"
        self.authentication = "Basic realm= Access to logs"
    }

    public func handleRoute(request: Request) -> RouteData {
        var body = "" 
        var responseLineData = packResponseLine(request: request, statusCode: "401", body: body) 
        let filePath = NSURL.fileURL(withPathComponents: ["requestLog.txt"])
        if (request.headers.keys.contains("Authorization")) {
            if (checkAuthorization(authorization: request.headers["Authorization"]!)) {
                body = readLogRequest(path: filePath!)
                responseLineData = packResponseLine(request: request, statusCode: "200", body: body) 
            }
        } 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
    }

    private func packResponseLine(request: Request, statusCode: String, body: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = statusCode 
        responseLineData["statusMessage"] = body
        return responseLineData
    }

    private func packResponseHeaders(body: String) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count) 
        headersData["Content-Type"] = "text/html"
        headersData["Allow"] = "GET" 
        headersData["WWW-Authenticate"] = authentication
        return headersData
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
