import Foundation
import Request
import ServerIO

public class Form: Route {

    let documentIO: DocumentIO 

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> RouteData {
        if (request.method == "POST" || request.method == "PUT") {
            manipulateTxt(request: request)
            let body = "" 
            let responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK") 
            let headersData = packResponseHeaders(body: body)
            return RouteData(responseLine: responseLineData, headers: headersData, body: body)
        } else {
            let body = "" 
            let responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed") 
            let headersData = packResponseHeaders(body: body)
            return RouteData(responseLine: responseLineData, headers: headersData, body: body)
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
        headersData["Content-Type"] = "text/plain; charset=utf-8"
        return headersData
    }
    public func manipulateTxt (request: Request) {
        let filePath = "data.txt"
        if (request.method == "POST") {
            documentIO.writeText(text: request.body, path: filePath)
        } else {
            let rawLogData = documentIO.readText(path: filePath)
            let updatedData = getUpdatedText(data: rawLogData, bodyText: request.body) 
            documentIO.writeText(text: updatedData, path: filePath)     
        }
    }

    private func getUpdatedText(data: String, bodyText: [String: String]) -> [String: String] {
        var logData: [String: String] = [:]
        let lineData = data.components(separatedBy: "\n")
        for text in lineData {
            let loggedData = text.split(separator: "=")
            logData[String(loggedData[0])] = String(loggedData[1])
        }
        for (key, _) in logData {
            if (key == Array(bodyText.keys)[0]) {
                logData[key] = bodyText[key]
            }
        } 
        return logData
    }

}
