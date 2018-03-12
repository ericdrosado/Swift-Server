import Foundation

public class Response {

    typealias PathHandler = (Response) -> (Request) -> String
    var paths: [String: PathHandler] = ["/": handleRoot,"/hello": handleHello,"/coffee": handleCoffee, "/tea": handleRoot, "/parameters": handleParameters, "/cookie": handleCookie, "/eat_cookie": handleEatCookie, "/redirect": handleRedirect, "/form": handleForm]
    let status200: String
    let status404: String
    let status404Body: String

    public init(){
        self.status200 = "200 OK"
        self.status404 = "404 Not Found"
        self.status404Body = "404 Page Not Found"
    }

    public func buildResponse(request: Request) -> String {
        if (paths.keys.contains(request.path)) {
            return paths[request.path]!(self)(request)
        } else {
            return handle404(request: request)
        }
    }

    private func handle404(request: Request) -> String {
        let body = prepareBody(body: status404Body, method: request.method) 
        let header = buildHeader(statusCode: status404, contentLength: body.utf8.count) 
        return header + body
    }

    private func handleRoot(request: Request) -> String {
        var body = request.path == "/" ? "Hello World": String()
        body = prepareBody(body: body, method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    } 

    private func handleHello(request: Request) -> String {
        let helloRequest = Request(method: request.method, path: request.path, queries: request.queries)
        let body = prepareBody(body: "Hello \(buildHelloBody(request: helloRequest))", method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }

    private func handleCoffee(request: Request) -> String {
        let body = "I'm a teapot"
        let header = buildHeader(statusCode: "418", contentLength: body.utf8.count)
        return header + body
    }

    private func handleParameters(request: Request) -> String {
        var body = prepareBody(body: "\(buildParameterBody(request: request))", method: request.method)
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }

    private func handleCookie(request: Request) -> String {
        let body = "Eat"
        let header = "HTTP/1.1 \(status200)\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\nSet-Cookie: type=chocolate\r\n\r\n" 
        return header + body
    }

    private func handleEatCookie(request: Request) -> String {
        let body = "mmmm \(request.cookie)"
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
        return header + body
    }

    private func handleRedirect(request: Request) -> String {
        let body = prepareBody(body: "Hello World", method: request.method)
        let header = "HTTP/1.1 302\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\nLocation: /\r\n\r\n" 
        return header + body
    }

    private func handleForm(request: Request) -> String {
        let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
        if (request.method == "POST") {
            writeText(requestBody: request.body, path: filePath!)
        } else {
            let rawLogData = readText(path: filePath!)
            let updatedData = getUpdatedText(data: rawLogData, bodyText: request.body) 
            writeText(requestBody: updatedData, path: filePath!)     
        }
        let body = ""
        let header = buildHeader(statusCode: status200, contentLength: body.utf8.count)
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
                print("Error reading data.txt. \(error)")
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
    
    private func prepareBody(body: String, method: String) -> String {
        if (method == "HEAD") {
            return ""    
        } else {
            return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
        }
    }

    private func buildHeader(statusCode: String, contentLength: Int) -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
    }

    private func buildParameterBody(request: Request) -> String {
         var queries = [String]()
         for (key, value) in request.queries {
             queries.append(key + " = ")
             queries.append(value)    
         }
         return queries
                .filter({$0 != ""})
                .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
                .joined(separator: " ")
    }

    private func buildHelloBody(request: Request) -> String {
        var queries = [String()]                                                                                         
        var queryKeys = ["fname","mname", "lname"]                                                                       
        for index in 0...queryKeys.count-1 {
            for (key, value) in request.queries {                                                                        
                if (key == queryKeys[index]) {
                    queries.append(value)
                } 
            }
        }                                                                                                            
        return queries
               .filter({$0 != ""})
               .map({$0.trimmingCharacters(in:.whitespacesAndNewlines)})
               .joined(separator: " ")
    }
    
}


