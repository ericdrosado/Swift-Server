import Foundation
import Request

public class CatForm: Route {

    let actions: [String: Action]
    let catFormPath: String
    let catFormDataPath: String

    public init() {
        self.actions = ["POST": Post()]
        self.catFormPath = "/cat-form"
        self.catFormDataPath = "/cat-form/data"
    }

    public func handleRoute(request: Request) -> RouteData {
        let filePath = "\(request.directory)\(request.path)"
        if (request.method != "POST" && request.path == catFormDataPath) {
            return CatForm.Data().handleRoute(path: filePath, request: request)
        } else if (request.method == "POST" && request.path == catFormPath) {
            return actions[request.method]!.handleRequest(request: request, path: filePath)
        } else {
            let body = ""
            return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "405", statusMessage: "Method Not Allowed", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body)
        }
    }
    
    public class Data {

        let actions: [String: Action]

        public init(){
            self.actions = ["GET": Get(), "PUT": Put(), "DELETE": Delete()]
        }

        public func handleRoute(path: String, request: Request) -> RouteData {
            return actions[request.method]!.handleRequest(request: request, path: path)
        }

        public class Get: Action {

            public func handleRequest(request: Request, path: String) -> RouteData {
                var body = ""
                if (FileManager.default.fileExists(atPath: path)) {
                    body = readText(path: path)
                    return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "200", statusMessage: "OK", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body) 
                } else {
                    return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "404", statusMessage: "Not Found", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body) 
                }
            }

            private func readText(path: String) -> String {
                let filePath = NSURL.fileURL(withPathComponents: [path])
                var logData: String = String()
                    do {
                        logData = try String(contentsOf: filePath!, encoding: String.Encoding.utf8) 
                    } catch {
                        print("Error reading text file. \(error)")
                    }
                return logData
            }
        }

        public class Put: Action {

            public func handleRequest(request: Request, path: String) -> RouteData {
                let body = ""
                let rawLogData = FileIO().readText(path: path)
                let updatedData = getUpdatedText(data: rawLogData, bodyText: request.body) 
                FileIO().writeText(requestBody: updatedData, path: path)     
                return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "200", statusMessage: "OK", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body) 
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

        public class Delete: Action {
        
            public func handleRequest(request: Request, path: String) -> RouteData {
                let body = ""
                if (FileManager.default.fileExists(atPath: path)) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        print("Error deleting file. \(error)")
                    }
                }
                return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "200", statusMessage: "OK", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body) 
            }

        }

    }
    
    public class Post: Action {
        
        public func handleRequest(request: Request, path: String) -> RouteData {
            let filePath = "\(path)/data"
            let body = "" 
            if (FileManager.default.fileExists(atPath: filePath)) {
                FileIO().writeText(requestBody: request.body, path: filePath)
                return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "200", statusMessage: "OK", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", body: body) 
            } else {
                FileIO().writeText(requestBody: request.body, path: filePath)
                let additionalHeader = ["Location": "/cat-form/data"]
                return ResponsePackager().packResponse(version: request.httpVersion, statusCode: "201", statusMessage: "Created", contentLength: String(body.utf8.count), contentType: "text/plain; charset=utf-8", additionalHeaders: additionalHeader, body: body) 
            }
        }

    }

}

public protocol Action {

    func handleRequest(request: Request, path: String) -> RouteData 

}

public class ResponsePackager {

    public init(){}

    public func packResponse(version: String, statusCode: String, statusMessage: String, contentLength: String, contentType: String, additionalHeaders: [String: String]? = nil, body: String) -> RouteData {
        let responseLineData = packResponseLine(version: version, statusCode: statusCode, statusMessage: statusMessage)
        let headerData = packResponseHeaders(contentLength: contentLength, contentType: contentType, additionalHeaders: additionalHeaders)
        return RouteData(responseLine: responseLineData, headers: headerData, body: body)        
    }

    public func packResponseLine(version: String, statusCode: String, statusMessage: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = version 
        responseLineData["statusCode"] = statusCode 
        responseLineData["statusMessage"] = statusMessage 
        return responseLineData
    }

    public func packResponseHeaders(contentLength: String, contentType: String, additionalHeaders: [String: String]? = nil) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = contentLength 
        headersData["Content-Type"] = contentType 
        if (additionalHeaders != nil) {
            for (key, value) in additionalHeaders! {
               headersData[key] = value
            }
        }
        return headersData
    }

}

public class FileIO {
   
    public init(){}

    public func writeText(requestBody: [String: String], path: String) {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        let text = requestBody.map{ "\($0)=\($1)" }.joined(separator:"\n")
        do {
            try text.write(to: filePath!, atomically: false,
                    encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to file. \(error)")
        }
    }

    public func readText(path: String) -> String {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        var data: String = String()
        do {
            data = try String(contentsOf: filePath!, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading text file. \(error)")
        }
        return data
    }

}
