import Foundation
import Request

public class File1: Route {

        public init(){}

        public func handleRoute(request: Request) -> RouteData {
            var body = readText(request: request)
            var responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK")
            if (request.method != "GET") {
                body = ""
                responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
            }
            let headersData = packResponseHeaders(body: body) 
            return RouteData(responseLine: responseLineData, headers: headersData, body: body) 
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
            headersData["Content-Type"] = "text/html"
            headersData["Allow"] = "GET"
            return headersData
        }
            
        private func readText(request: Request) -> String {
            let path = NSURL.fileURL(withPathComponents: ["\(request.directory)/file1"])
            var fileData: String = String()
            do {
                fileData = try String(contentsOf: path!, encoding: String.Encoding.utf8) 
            } catch {
                print("Error reading text file. \(error)")
            }
            return fileData
        }

}
