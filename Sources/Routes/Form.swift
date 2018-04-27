import Foundation
import Request
import Response
import ServerIO

public class Form: Route {

    let documentIO: DocumentIO 

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> ResponseData {
        manipulateTxt(request: request)
        let body = ""      
        return ResponseData(statusLine: Status.status200(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body)   
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
