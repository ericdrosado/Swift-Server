import Foundation
import Request
import Response
import ServerIO

public class Logs: Route {

    let documentIO: DocumentIO 
    let userName: String
    let password: String
    let authentication: String

    public init(documentIO: DocumentIO){
        self.documentIO = documentIO
        self.userName = "admin"
        self.password = "hunter2"
        self.authentication = "Basic realm= Access to logs"
    }

    public func handleRoute(request: Request) -> ResponseData {
        var body = "" 
        var status = Status.status401(version: request.httpVersion)
        let filePath = "requestLog.txt"
        if (request.headers.keys.contains("Authorization")) {
            if (checkAuthorization(authorization: request.headers["Authorization"]!)) {
                body = documentIO.readText(path: filePath)
                status = Status.status200(version: request.httpVersion)
            }
        } 
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["WWW-Authenticate": authentication]), 
                            body: body)
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
