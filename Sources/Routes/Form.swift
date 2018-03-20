import Foundation
import Request

public class Form: Route {

    public init(){}

    public func handleRoute(request: Request) -> String {
        let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
        if (request.method == "POST") {
            writeText(requestBody: request.body, path: filePath!)
        } else {
            let rawLogData = readText(path: filePath!)
            let updatedData = getUpdatedText(data: rawLogData, bodyText: request.body) 
            writeText(requestBody: updatedData, path: filePath!)     
        }
        let body = ""
        let header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
        return header + body
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

    private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }
}
