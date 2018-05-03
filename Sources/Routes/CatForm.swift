import Foundation
import Request
import Response
import ServerIO

public class CatForm: Route {

    let catFormPath: String
    let catFormDataPath: String

    public init() {
        self.catFormPath = "/cat-form"
        self.catFormDataPath = "/cat-form/data"
    }

    public func handleRoute(request: Request) -> ResponseData {
        var filePath = "\(request.directory)\(request.path)"
        let body = ""
        if (request.method == "POST") {
            filePath += "/data"
            DocumentIO().writeText(text: request.body, path: filePath)
            return ResponseData(statusLine: Status.status201(version: request.httpVersion) ,
                                headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Location": "\(request.path)/data"]),
                                body: body)
        } else if (request.path == catFormDataPath) {
            return CatForm.Data().handleRoute(path: filePath, request: request)
        }
        return ResponseData(statusLine: Status.status200(version: request.httpVersion) ,
                            headers: Headers().getHeaders(body: body, route: request.path),
                            body: body)
    }
    
    public class Data {

        public init(){}

        public func handleRoute(path: String, request: Request) -> ResponseData {
            if (request.method == "GET") {
                return getRequest(path: path, request: request)
            } else if (request.method == "PUT") {
                return putRequest(path: path, request: request)
            } else {
                return deleteRequest(path: path, request: request)
            } 
        }

        private func getRequest(path: String, request: Request) -> ResponseData {
            var body = ""
            if (FileManager.default.fileExists(atPath: path)) {
                body = DocumentIO().readText(path: path)
                return ResponseData(statusLine: Status.status200(version: request.httpVersion) ,
                                    headers: Headers().getHeaders(body: body, route: request.path),
                                    body: body)
            } else {
                return ResponseData(statusLine: Status.status404(version: request.httpVersion) ,
                                    headers: Headers().getHeaders(body: body, route: request.path),
                                    body: body)
            }
        }

        private func putRequest(path: String, request: Request) -> ResponseData {
            let body = ""
            let rawData = DocumentIO().readText(path: path)
            let updatedData = getUpdatedText(data: rawData, bodyText: request.body) 
            DocumentIO().writeText(text: updatedData, path: path)   
            return ResponseData(statusLine: Status.status200(version: request.httpVersion) ,
                                headers: Headers().getHeaders(body: body, route: request.path),
                                body: body)  
        }

        private func deleteRequest(path: String, request: Request) -> ResponseData {
            let body = ""
            if (FileManager.default.fileExists(atPath: path)) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("Error deleting file. \(error)")
                }
            }
            return ResponseData(statusLine: Status.status200(version: request.httpVersion) ,
                                headers: Headers().getHeaders(body: body, route: request.path),
                                body: body)
        }

        private func getUpdatedText(data: String, bodyText: [String: String]) -> [String: String] {
                var documentData: [String: String] = [:]
                let lineData = data.components(separatedBy: "\n")
                for text in lineData {
                    let loggedData = text.split(separator: "=")
                    documentData[String(loggedData[0])] = String(loggedData[1])
                }
                for (key, _) in documentData {
                    if (key == Array(bodyText.keys)[0]) {
                        documentData[key] = bodyText[key]
                    }
                } 
                return documentData
            }

    }

}