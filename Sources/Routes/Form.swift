import Foundation
import Request

public class Form: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData{
        manipulateTxt(request: request)
        let body = "" 
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body)
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
        headersData["Allow"] = "GET, HEAD, PUT, POST, OPTIONS" 
        return headersData
    }
    public func manipulateTxt (request: Request) {
        let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
        if (request.method == "POST") {
            writeText(requestBody: request.body, path: filePath!)
        } else {
            let rawLogData = readText(path: filePath!)
            let updatedData = getUpdatedText(data: rawLogData, bodyText: request.body) 
            writeText(requestBody: updatedData, path: filePath!)     
        }
    }

    private func writeText(requestBody: [String: String], path: URL) {
        let text =  requestBody.map{ "\($0)=\($1)" }.joined(separator:"\n")
        do {
            try text.write(to: path, atomically: false,
            encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to data.txt. \(error)")
        }
    }

    private func readText(path: URL) -> String {
        var logData: String = String()
            do {
                logData = try String(contentsOf: path, encoding: String.Encoding.utf8) 
            } catch {
                print("Error reading text file. \(error)")
            }
        return logData
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
